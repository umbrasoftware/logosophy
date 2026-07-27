-- Enable RLS ahead of the publishable-key migration.
--
-- Safe to run against production as-is: the currently deployed app authenticates
-- with the secret key (service_role), which bypasses RLS, so nothing below
-- affects clients in the field. These policies define what the *next* release
-- is allowed to do once it switches to the publishable key.
--
-- App's entire Supabase surface:
--   documents          read only via match_documents(), server-side
--   feedback           insert only, from the support form
--   storage: books     signed-url + download of books.zip / mapping.json

-- ---------------------------------------------------------------------------
-- documents: no client access at all.
-- ---------------------------------------------------------------------------
-- Only the search edge function reaches this, using the secret key. Deliberately
-- policy-less: RLS with zero policies denies every non-service role.

alter table public.documents enable row level security;
alter table public.documents force row level security;

-- ---------------------------------------------------------------------------
-- match_documents: server-side only.
-- ---------------------------------------------------------------------------
-- Signature is unknown here (and may have overloads), so drive it off the
-- catalog. SECURITY INVOKER matters: if this function were DEFINER-owned by
-- postgres it would read documents with RLS bypassed even when anon calls it,
-- quietly undoing the block above.

do $$
declare
  fn record;
begin
  for fn in
    select p.oid::regprocedure as sig
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname = 'match_documents'
  loop
    execute format('alter function %s security invoker', fn.sig);
    execute format('revoke all on function %s from public, anon, authenticated', fn.sig);
    execute format('grant execute on function %s to service_role', fn.sig);
    raise notice 'locked down %', fn.sig;
  end loop;
end
$$;

-- ---------------------------------------------------------------------------
-- feedback: write-only for anon.
-- ---------------------------------------------------------------------------
-- No SELECT policy on purpose. This table holds names, emails and device info;
-- a SELECT policy broad enough to satisfy PostgREST's RETURNING clause would
-- also let any client read every row ever submitted.
--
-- Consequence: the `.select('id')` in support_page.dart:173 stops working under
-- the publishable key. See the note at the bottom of this file.

alter table public.feedback enable row level security;

drop policy if exists "anon can submit feedback" on public.feedback;
create policy "anon can submit feedback"
  on public.feedback
  for insert
  to anon
  with check (true);

-- ---------------------------------------------------------------------------
-- storage: read-only access to the books bucket.
-- ---------------------------------------------------------------------------
-- createSignedUrl() and download() both require SELECT on storage.objects.
-- This bucket's contents ship to every user of the app anyway, so anon read is
-- no more exposure than the app already provides. (If you'd rather not have the
-- zips fetchable by anyone holding the publishable key, drop this policy and
-- mint the signed URL inside an edge function instead.)

drop policy if exists "anon can read books bucket" on storage.objects;
create policy "anon can read books bucket"
  on storage.objects
  for select
  to anon
  using (bucket_id = 'books');

-- ---------------------------------------------------------------------------
-- Verification.
-- ---------------------------------------------------------------------------
-- Anything listed by the first query is reachable by anyone holding the
-- publishable key. Expect an empty result.

select
  c.relname as unprotected_table,
  c.relrowsecurity as rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'r'
  and not c.relrowsecurity;

-- Every policy now in force, so you can eyeball the whole set at once.
select schemaname, tablename, policyname, roles, cmd
from pg_policies
where schemaname in ('public', 'storage')
order by schemaname, tablename, policyname;

-- Public buckets ignore the policy above entirely. `books` should read false.
select id, public from storage.buckets;

-- ---------------------------------------------------------------------------
-- Follow-up required before the key swap
-- ---------------------------------------------------------------------------
-- support_page.dart:163-180 does .insert(...).select('id') and infers success
-- from the returned id. With no SELECT policy that call fails under the
-- publishable key. Change it to a bare .insert(...) and treat a thrown
-- PostgrestException as the failure signal.
