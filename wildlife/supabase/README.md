# Supabase Setup

1. Create a new Supabase project.
2. Create a storage bucket named `sightings-photos` and set it to public.
3. Run `schema.sql` in the SQL editor to create tables and policies.
4. Use the anon key in the app; keep the service role key secret.
5. Set `SUPABASE_URL` and `SUPABASE_ANON_KEY` in `.env` (see `.env.example`).

Optional: add PostGIS or use point types later; MVP uses simple lat/lng doubles.