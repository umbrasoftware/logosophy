-- Per-IP rate limiting for the search edge function.
--
-- Edge function isolates are ephemeral and there are many of them, so the
-- counter cannot live in function memory. It lives here instead: one rpc per
-- request, atomic, no extra infrastructure.

create table if not exists public.rate_limits (
  key text primary key,
  window_start timestamptz not null default now(),
  count integer not null default 0
);

-- Only the edge function's service_role connection touches this table.
alter table public.rate_limits enable row level security;

-- Fixed-window counter. The upsert-with-returning takes a row lock, so two
-- concurrent requests serialize rather than both reading a stale count and
-- slipping past the limit.
--
-- `key` is a salted SHA-256 of the caller's IP, hashed in the edge function.
-- Raw addresses never reach the database.
create or replace function public.check_rate_limit(
  p_key text,
  p_limit integer,
  p_window interval
)
returns boolean
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_count integer;
begin
  insert into public.rate_limits as r (key, window_start, count)
  values (p_key, now(), 1)
  on conflict (key) do update
    set count = case
          when r.window_start < now() - p_window then 1
          else r.count + 1
        end,
        window_start = case
          when r.window_start < now() - p_window then now()
          else r.window_start
        end
  returning r.count into v_count;

  -- Opportunistic cleanup so the table stays bounded without needing pg_cron.
  -- Roughly one request in a thousand pays for it.
  if random() < 0.001 then
    delete from public.rate_limits where window_start < now() - interval '1 day';
  end if;

  return v_count <= p_limit;
end;
$$;

-- Same lockdown as match_documents: server-side callers only.
revoke all on function public.check_rate_limit(text, integer, interval)
  from public, anon, authenticated;
grant execute on function public.check_rate_limit(text, integer, interval)
  to service_role;
