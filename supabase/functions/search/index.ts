// Embeds the query and runs the vector search server-side, so no OpenAI key
// ships in the app bundle.
//
// Returns the same JSON array shape the app previously got straight from
// PostgREST's /rpc/match_documents, so SearchResult.fromJson is unchanged.

import { createClient } from 'jsr:@supabase/supabase-js@2';

const OPENAI_API_KEY = Deno.env.get('OPENAI_API_KEY')!;
const IP_SALT = Deno.env.get('RATE_LIMIT_IP_SALT')!;
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;

// SUPABASE_SERVICE_ROLE_KEY is injected automatically, but it is the *legacy*
// JWT-format key. DB_SECRET_KEY is the escape hatch: set it to an sb_secret_...
// key if the legacy ones are ever disabled on this project.
const SERVICE_KEY = Deno.env.get('DB_SECRET_KEY') ?? Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

const EMBEDDING_MODEL = 'text-embedding-3-small';

// Anyone holding the publishable key can reach this function, so every limit is
// enforced here regardless of what the client claims to be sending.
const MAX_QUERY_CHARS = 500;
const MAX_MATCH_COUNT = 50;
const DEFAULT_MATCH_COUNT = 20;
const MAX_BOOK_IDS = 200;

const RATE_LIMIT = 30;
const RATE_WINDOW = '1 minute';

const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

class BadRequest extends Error {}

function json(body: unknown, status = 200, extraHeaders: Record<string, string> = {}) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, ...extraHeaders, 'Content-Type': 'application/json' },
  });
}

/// Salted hash, so the rate-limit table holds no personal data.
async function hashIp(ip: string): Promise<string> {
  const bytes = new TextEncoder().encode(`${IP_SALT}:${ip}`);
  const digest = await crypto.subtle.digest('SHA-256', bytes);
  return Array.from(new Uint8Array(digest))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

/// match_documents treats null and empty as "no filter"; normalise to null.
function parseBookIds(value: unknown, field: string): string[] | null {
  if (value === null || value === undefined) return null;
  if (!Array.isArray(value) || value.some((v) => typeof v !== 'string')) {
    throw new BadRequest(`${field} must be an array of strings`);
  }
  if (value.length > MAX_BOOK_IDS) {
    throw new BadRequest(`${field} exceeds ${MAX_BOOK_IDS} entries`);
  }
  return value.length > 0 ? value : null;
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: CORS });
  if (req.method !== 'POST') return json({ error: 'method not allowed' }, 405);

  let query: string;
  let matchCount: number;
  let includeBookIds: string[] | null;
  let excludeBookIds: string[] | null;

  try {
    const payload = await req.json();

    if (typeof payload?.query !== 'string') throw new BadRequest('query must be a string');
    query = payload.query.trim();
    if (query.length === 0) throw new BadRequest('query is empty');
    if (query.length > MAX_QUERY_CHARS) {
      throw new BadRequest(`query exceeds ${MAX_QUERY_CHARS} characters`);
    }

    const requested = payload.matchCount;
    if (requested === null || requested === undefined) {
      matchCount = DEFAULT_MATCH_COUNT;
    } else if (!Number.isInteger(requested) || requested < 1) {
      throw new BadRequest('matchCount must be a positive integer');
    } else {
      matchCount = Math.min(requested, MAX_MATCH_COUNT);
    }

    includeBookIds = parseBookIds(payload.includeBookIds, 'includeBookIds');
    excludeBookIds = parseBookIds(payload.excludeBookIds, 'excludeBookIds');
  } catch (e) {
    if (e instanceof BadRequest) return json({ error: e.message }, 400);
    return json({ error: 'invalid json' }, 400);
  }

  const admin = createClient(SUPABASE_URL, SERVICE_KEY, { auth: { persistSession: false } });

  // x-forwarded-for is a comma-separated chain; the client is the first entry.
  const forwarded = req.headers.get('x-forwarded-for') ?? '';
  const ip = forwarded.split(',')[0].trim() || 'unknown';

  const { data: allowed, error: rateError } = await admin.rpc('check_rate_limit', {
    p_key: await hashIp(ip),
    p_limit: RATE_LIMIT,
    p_window: RATE_WINDOW,
  });

  // Fail closed: if the limiter is broken, the endpoint is unmetered.
  if (rateError) {
    console.error('rate limit check failed:', rateError);
    return json({ error: 'internal error' }, 500);
  }
  if (!allowed) {
    return json({ error: 'rate limit exceeded' }, 429, { 'Retry-After': '60' });
  }

  const embedResponse = await fetch('https://api.openai.com/v1/embeddings', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${OPENAI_API_KEY}`,
    },
    body: JSON.stringify({ model: EMBEDDING_MODEL, input: query }),
  });

  if (!embedResponse.ok) {
    console.error('embedding failed:', embedResponse.status, await embedResponse.text());
    return json({ error: 'embedding failed' }, 502);
  }

  const embedding = (await embedResponse.json()).data[0].embedding;

  const { data, error } = await admin.rpc('match_documents', {
    query_embedding: embedding,
    match_count: matchCount,
    include_book_ids: includeBookIds,
    exclude_book_ids: excludeBookIds,
  });

  if (error) {
    console.error('match_documents failed:', error);
    return json({ error: 'search failed' }, 500);
  }

  return json(data);
});
