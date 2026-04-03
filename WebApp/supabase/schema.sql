-- ClickLocal – Supabase Schema
-- Run this in Supabase SQL Editor to create all tables

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ── Venues ──────────────────────────────────────────────────
create table public.venues (
  id              uuid primary key default uuid_generate_v4(),
  owner_id        text not null,          -- Clerk user ID
  name            text not null,
  type            text not null check (type in ('food', 'service', 'both')),
  description     text not null default '',
  status          text not null default 'closed' check (status in ('open', 'closed')),
  status_updated_at timestamptz not null default now(),
  is_active       boolean not null default true,
  tags            text[] not null default '{}',

  -- contact (flattened)
  phone           text not null,
  bot_phone       text not null unique,
  instagram       text,

  -- location (flattened)
  lat             double precision not null,
  lng             double precision not null,
  location_reference text not null,
  address         text,
  is_ambulatory   boolean not null default false,

  -- media
  logo_url        text,
  cover_url       text,

  -- daily update
  daily_text      text,
  daily_image_url text,
  daily_updated_at timestamptz,

  -- stats
  views           integer not null default 0,
  whatsapp_taps   integer not null default 0,

  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- ── Menu Items ───────────────────────────────────────────────
create table public.menu_items (
  id           uuid primary key default uuid_generate_v4(),
  venue_id     uuid not null references public.venues(id) on delete cascade,
  name         text not null,
  description  text,
  price        numeric(10,2),
  image_url    text,
  category     text not null default 'General',
  is_available boolean not null default true,
  "order"      integer not null default 0,
  created_at   timestamptz not null default now()
);

-- ── Services ─────────────────────────────────────────────────
create table public.services (
  id           uuid primary key default uuid_generate_v4(),
  venue_id     uuid not null references public.venues(id) on delete cascade,
  name         text not null,
  description  text,
  price        numeric(10,2),
  duration     integer,                   -- minutes
  image_url    text,
  is_available boolean not null default true,
  "order"      integer not null default 0,
  created_at   timestamptz not null default now()
);

-- ── Row Level Security ────────────────────────────────────────
alter table public.venues enable row level security;
alter table public.menu_items enable row level security;
alter table public.services enable row level security;

-- Venues: lectura pública, escritura solo del dueño
create policy "venues_read_public" on public.venues
  for select using (is_active = true);

create policy "venues_insert_owner" on public.venues
  for insert with check (true);        -- validado en servidor via Clerk

create policy "venues_update_owner" on public.venues
  for update using (true);             -- validado en servidor via Clerk

-- Menu items: lectura pública
create policy "menu_items_read_public" on public.menu_items
  for select using (
    exists (select 1 from public.venues v where v.id = venue_id and v.is_active = true)
  );

create policy "menu_items_write" on public.menu_items
  for all using (true);                -- validado en servidor

-- Services: lectura pública
create policy "services_read_public" on public.services
  for select using (
    exists (select 1 from public.venues v where v.id = venue_id and v.is_active = true)
  );

create policy "services_write" on public.services
  for all using (true);                -- validado en servidor

-- ── Realtime ─────────────────────────────────────────────────
-- Requerido para que Supabase Realtime envíe datos completos del cambio
ALTER TABLE public.venues REPLICA IDENTITY FULL;
ALTER TABLE public.menu_items REPLICA IDENTITY FULL;
ALTER TABLE public.services REPLICA IDENTITY FULL;

-- Agregar a la publicación de Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.venues;

-- Permisos para usuarios anónimos (Realtime)
GRANT SELECT ON public.venues TO anon;
GRANT SELECT ON public.venues TO authenticated;
GRANT SELECT ON public.menu_items TO anon;
GRANT SELECT ON public.menu_items TO authenticated;
GRANT SELECT ON public.services TO anon;
GRANT SELECT ON public.services TO authenticated;

-- ── Índices para performance ──────────────────────────────────
create index venues_is_active_idx on public.venues(is_active);
create index venues_status_idx on public.venues(status);
create index venues_owner_idx on public.venues(owner_id);
create index venues_bot_phone_idx on public.venues(bot_phone);
create index menu_items_venue_idx on public.menu_items(venue_id);
create index services_venue_idx on public.services(venue_id);
