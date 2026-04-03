import { supabase } from "@/lib/supabase";
import { Venue, MenuItem, Service, VenueWithDistance } from "@/types";

function haversineKm(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

function rowToVenue(row: Record<string, unknown>): Venue {
  return {
    id: row.id as string,
    name: row.name as string,
    type: row.type as Venue["type"],
    description: row.description as string,
    status: row.status as Venue["status"],
    status_updated_at: row.status_updated_at as string,
    is_active: row.is_active as boolean,
    tags: (row.tags as string[]) ?? [],
    owner_id: row.owner_id as string,
    created_at: row.created_at as string,
    updated_at: row.updated_at as string,
    contact: {
      phone: row.phone as string,
      bot_phone: row.bot_phone as string,
      instagram: row.instagram as string | null,
    },
    location: {
      lat: row.lat as number,
      lng: row.lng as number,
      reference: row.location_reference as string,
      address: row.address as string | null,
      is_ambulatory: row.is_ambulatory as boolean,
    },
    media: {
      logo_url: row.logo_url as string | null,
      cover_url: row.cover_url as string | null,
    },
    daily_update: row.daily_text || row.daily_image_url
      ? {
          text: row.daily_text as string | null,
          image_url: row.daily_image_url as string | null,
          updated_at: row.daily_updated_at as string,
        }
      : null,
    stats: {
      views: row.views as number,
      whatsapp_taps: row.whatsapp_taps as number,
    },
    telegram_chat_id: (row.telegram_chat_id as string | null) ?? null,
  };
}

export async function getActiveVenues(): Promise<Venue[]> {
  const { data, error } = await supabase
    .from("venues")
    .select("*")
    .eq("is_active", true)
    .order("status", { ascending: false }) // open first
    .order("name");

  if (error) throw new Error(error.message);
  return (data ?? []).map(rowToVenue);
}

export async function getVenuesSortedByDistance(
  userLat: number,
  userLon: number,
  radiusKm = 20
): Promise<VenueWithDistance[]> {
  const venues = await getActiveVenues();
  return venues
    .map((v) => ({
      ...v,
      distance_km: haversineKm(userLat, userLon, v.location.lat, v.location.lng),
    }))
    .filter((v) => v.distance_km <= radiusKm)
    .sort((a, b) => a.distance_km - b.distance_km);
}

export async function getVenueById(venueId: string): Promise<Venue | null> {
  const { data, error } = await supabase
    .from("venues")
    .select("*")
    .eq("id", venueId)
    .single();

  if (error || !data) return null;
  return rowToVenue(data);
}

export async function getMenuItems(venueId: string): Promise<MenuItem[]> {
  const { data, error } = await supabase
    .from("menu_items")
    .select("*")
    .eq("venue_id", venueId)
    .eq("is_available", true)
    .order("order");

  if (error) throw new Error(error.message);
  return (data ?? []).map((row) => ({
    id: row.id,
    venue_id: row.venue_id,
    name: row.name,
    description: row.description,
    price: row.price,
    image_url: row.image_url,
    category: row.category,
    is_available: row.is_available,
    order: row.order,
    created_at: row.created_at,
  }));
}

export async function getServices(venueId: string): Promise<Service[]> {
  const { data, error } = await supabase
    .from("services")
    .select("*")
    .eq("venue_id", venueId)
    .eq("is_available", true)
    .order("order");

  if (error) throw new Error(error.message);
  return (data ?? []).map((row) => ({
    id: row.id,
    venue_id: row.venue_id,
    name: row.name,
    description: row.description,
    price: row.price,
    duration: row.duration,
    image_url: row.image_url,
    is_available: row.is_available,
    order: row.order,
    created_at: row.created_at,
  }));
}

export async function incrementVenueViews(venueId: string): Promise<void> {
  await supabase.rpc("increment_venue_views", { venue_id: venueId });
}

export async function incrementWhatsappTaps(venueId: string): Promise<void> {
  await supabase.rpc("increment_whatsapp_taps", { venue_id: venueId });
}

export async function getVenuesByOwner(ownerId: string): Promise<Venue[]> {
  const { data, error } = await supabase
    .from("venues")
    .select("*")
    .eq("owner_id", ownerId);

  if (error) throw new Error(error.message);
  return (data ?? []).map(rowToVenue);
}

export async function isBotPhoneUnique(botPhone: string, excludeVenueId?: string): Promise<boolean> {
  let query = supabase.from("venues").select("id").eq("bot_phone", botPhone);
  const { data } = await query;
  if (!data || data.length === 0) return true;
  if (excludeVenueId && data.length === 1 && data[0].id === excludeVenueId) return true;
  return false;
}

export async function createVenue(
  ownerId: string,
  venue: Omit<Venue, "id" | "created_at" | "updated_at" | "stats" | "status_updated_at">
): Promise<string> {
  const { data, error } = await supabase.from("venues").insert({
    owner_id: ownerId,
    name: venue.name,
    type: venue.type,
    description: venue.description,
    status: venue.status,
    is_active: venue.is_active,
    tags: venue.tags,
    phone: venue.contact.phone,
    bot_phone: venue.contact.bot_phone,
    instagram: venue.contact.instagram,
    lat: venue.location.lat,
    lng: venue.location.lng,
    location_reference: venue.location.reference,
    address: venue.location.address,
    is_ambulatory: venue.location.is_ambulatory,
    logo_url: venue.media.logo_url,
    cover_url: venue.media.cover_url,
    daily_text: venue.daily_update?.text,
    daily_image_url: venue.daily_update?.image_url,
    daily_updated_at: venue.daily_update?.updated_at,
  }).select("id").single();

  if (error) throw new Error(error.message);
  return data.id;
}

export async function updateVenue(venueId: string, updates: Partial<Venue>): Promise<void> {
  const payload: Record<string, unknown> = { updated_at: new Date().toISOString() };
  if (updates.name) payload.name = updates.name;
  if (updates.type) payload.type = updates.type;
  if (updates.description !== undefined) payload.description = updates.description;
  if (updates.status) { payload.status = updates.status; payload.status_updated_at = new Date().toISOString(); }
  if (updates.is_active !== undefined) payload.is_active = updates.is_active;
  if (updates.tags) payload.tags = updates.tags;
  if (updates.contact) {
    payload.phone = updates.contact.phone;
    payload.bot_phone = updates.contact.bot_phone;
    payload.instagram = updates.contact.instagram;
  }
  if (updates.location) {
    payload.lat = updates.location.lat;
    payload.lng = updates.location.lng;
    payload.location_reference = updates.location.reference;
    payload.address = updates.location.address;
    payload.is_ambulatory = updates.location.is_ambulatory;
  }
  if (updates.media) {
    payload.logo_url = updates.media.logo_url;
    payload.cover_url = updates.media.cover_url;
  }
  if (updates.daily_update !== undefined) {
    payload.daily_text = updates.daily_update?.text ?? null;
    payload.daily_image_url = updates.daily_update?.image_url ?? null;
    payload.daily_updated_at = updates.daily_update?.updated_at ?? null;
  }

  const { error } = await supabase.from("venues").update(payload).eq("id", venueId);
  if (error) throw new Error(error.message);
}

export async function getFeedVenues(): Promise<Venue[]> {
  const venues = await getActiveVenues();
  return venues
    .filter((v) => v.daily_update?.text || v.daily_update?.image_url)
    .sort((a, b) => {
      const aTs = a.daily_update?.updated_at ? new Date(a.daily_update.updated_at).getTime() : 0;
      const bTs = b.daily_update?.updated_at ? new Date(b.daily_update.updated_at).getTime() : 0;
      return bTs - aTs;
    });
}
