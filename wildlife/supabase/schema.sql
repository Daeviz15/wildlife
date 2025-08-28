-- Supabase schema for Wildlife NG
create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz default now()
);

create table if not exists public.sightings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  species_name text not null,
  category text,
  notes text,
  lat double precision not null,
  lng double precision not null,
  accuracy_m double precision,
  photo_url text not null,
  created_at timestamptz default now(),
  status text default 'published'
);

-- Indexes
create index if not exists sightings_created_at_idx on public.sightings(created_at desc);
create index if not exists sightings_user_id_idx on public.sightings(user_id);

-- RLS
alter table public.profiles enable row level security;
alter table public.sightings enable row level security;

-- Profiles policies
create policy if not exists "Profiles are readable by owner" on public.profiles
  for select using (auth.uid() = user_id);
create policy if not exists "Profiles are insertable by owner" on public.profiles
  for insert with check (auth.uid() = user_id);
create policy if not exists "Profiles are updatable by owner" on public.profiles
  for update using (auth.uid() = user_id);

-- Sightings policies
-- Public read (location is public per requirement)
create policy if not exists "Sightings readable by anyone" on public.sightings
  for select using (true);

-- Authenticated users can insert
create policy if not exists "Sightings insert by authenticated" on public.sightings
  for insert with check (auth.role() = 'authenticated');

-- Owners can update/delete their own
create policy if not exists "Sightings update by owner" on public.sightings
  for update using (auth.uid() = user_id);
create policy if not exists "Sightings delete by owner" on public.sightings
  for delete using (auth.uid() = user_id);

-- Storage bucket note (create manually in Supabase dashboard):
-- Create storage bucket `sightings-photos` with public access.
