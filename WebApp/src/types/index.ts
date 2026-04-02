export type VenueType = "food" | "service" | "both";
export type VenueStatus = "open" | "closed";

export interface VenueLocation {
  lat: number;
  lng: number;
  reference: string;
  address: string | null;
  is_ambulatory: boolean;
}

export interface VenueContact {
  phone: string;
  bot_phone: string;
  instagram: string | null;
}

export interface VenueMedia {
  logo_url: string | null;
  cover_url: string | null;
}

export interface DailyUpdate {
  text: string | null;
  image_url: string | null;
  updated_at: string;
}

export interface VenueStats {
  views: number;
  whatsapp_taps: number;
}

export interface Venue {
  id: string;
  name: string;
  type: VenueType;
  description: string;
  status: VenueStatus;
  status_updated_at: string;
  is_active: boolean;
  contact: VenueContact;
  location: VenueLocation;
  media: VenueMedia;
  daily_update: DailyUpdate | null;
  stats: VenueStats;
  tags: string[];
  owner_id: string;
  created_at: string;
  updated_at: string;
}

export interface MenuItem {
  id: string;
  venue_id: string;
  name: string;
  description: string | null;
  price: number | null;
  image_url: string | null;
  category: string;
  is_available: boolean;
  order: number;
  created_at: string;
}

export interface Service {
  id: string;
  venue_id: string;
  name: string;
  description: string | null;
  price: number | null;
  duration: number | null;
  image_url: string | null;
  is_available: boolean;
  order: number;
  created_at: string;
}

export interface Owner {
  id: string;
  display_name: string;
  email: string;
  phone: string;
  venue_ids: string[];
  created_at: string;
  updated_at: string;
}

export interface VenueWithDistance extends Venue {
  distance_km: number;
}
