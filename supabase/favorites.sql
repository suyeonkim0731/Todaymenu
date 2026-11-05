-- Supabase SQL Editor에서 실행합니다. 기존 테이블은 덮어쓰지 않습니다.
begin;

create table public.favorites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  recipe_id bigint not null check (recipe_id > 0),
  created_at timestamptz not null default now(),
  constraint favorites_user_recipe_unique unique (user_id, recipe_id)
);

create index favorites_user_created_at_idx on public.favorites (user_id, created_at desc);
alter table public.favorites enable row level security;

revoke all on public.favorites from public, anon, authenticated;
grant select, insert, delete on public.favorites to authenticated;

create policy favorites_select_own on public.favorites
  for select to authenticated using ((select auth.uid()) = user_id);
create policy favorites_insert_own on public.favorites
  for insert to authenticated with check ((select auth.uid()) = user_id);
create policy favorites_delete_own on public.favorites
  for delete to authenticated using ((select auth.uid()) = user_id);

commit;
