create table if not exists public.rooms (
  id text primary key,
  state jsonb not null default '{}'::jsonb,
  version integer not null default 1,
  host_client_id text,
  x_client_id text,
  o_client_id text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists rooms_version_idx on public.rooms (version);
create index if not exists rooms_updated_at_idx on public.rooms (updated_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists rooms_set_updated_at on public.rooms;
create trigger rooms_set_updated_at
before update on public.rooms
for each row
execute function public.set_updated_at();

alter table public.rooms enable row level security;

drop policy if exists rooms_select on public.rooms;
create policy rooms_select
on public.rooms
for select
using (true);

drop policy if exists rooms_insert on public.rooms;
create policy rooms_insert
on public.rooms
for insert
with check (true);

drop policy if exists rooms_update on public.rooms;
create policy rooms_update
on public.rooms
for update
using (true)
with check (true);

drop policy if exists rooms_delete on public.rooms;
create policy rooms_delete
on public.rooms
for delete
using (true);
