-- ═══════════════════════════════════════════
-- ScholarID Pro — Supabase Setup SQL
-- Run this in Supabase SQL Editor
-- ═══════════════════════════════════════════

-- 1. SCHOOLS TABLE
create table if not exists schools (
  id uuid default gen_random_uuid() primary key,
  name text not null,
  address text,
  phone text,
  website text,
  affiliation text,
  session text default '2024-25',
  managed_by text,
  template integer default 1,
  logo_url text,
  sig_url text,
  created_at timestamp with time zone default now()
);

-- 2. STUDENTS TABLE
create table if not exists students (
  id uuid default gen_random_uuid() primary key,
  school_id uuid references schools(id) on delete cascade,
  name text not null,
  roll text,
  class text,
  section text,
  father_name text,
  mother_name text,
  dob text,
  blood_group text,
  mobile text,
  address text,
  photo_url text,
  created_at timestamp with time zone default now()
);

-- 3. ROW LEVEL SECURITY (open access for now)
alter table schools enable row level security;
alter table students enable row level security;

create policy "public_schools" on schools for all using (true) with check (true);
create policy "public_students" on students for all using (true) with check (true);

-- 4. STORAGE BUCKETS (run separately if these fail — create manually in Storage tab)
insert into storage.buckets (id, name, public) values ('photos', 'photos', true) on conflict do nothing;
insert into storage.buckets (id, name, public) values ('assets', 'assets', true) on conflict do nothing;

-- 5. STORAGE POLICIES
create policy "public_photos_read" on storage.objects for select using (bucket_id in ('photos','assets'));
create policy "public_photos_insert" on storage.objects for insert with check (bucket_id in ('photos','assets'));
create policy "public_photos_delete" on storage.objects for delete using (bucket_id in ('photos','assets'));
