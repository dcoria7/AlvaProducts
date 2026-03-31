import { Timestamp, GeoPoint } from "firebase/firestore";

export type VenueType = "food" | "service" | "both";
export type VenueStatus = "open" | "closed";

export interface VenueLocation {
  coordinates: GeoPoint;
  reference: string;       // "Col. Narvarte, CDMX"
  address: string | null;  // solo si tiene dirección física
  isAmbulatory: boolean;
}

export interface VenueContact {
  phone: string;           // número que el usuario ve y contacta
  botPhone: string;        // número desde donde el dueño manda comandos al bot
  instagram: string | null;
}

export interface VenueMedia {
  logoUrl: string;
  coverUrl: string | null;
}

export interface DailyUpdate {
  text: string | null;
  imageUrl: string | null;
  updatedAt: Timestamp;
}

export interface VenueStats {
  views: number;
  whatsappTaps: number;
}

export interface Venue {
  id: string;
  name: string;
  type: VenueType;
  description: string;
  status: VenueStatus;
  statusUpdatedAt: Timestamp;
  isActive: boolean;
  contact: VenueContact;
  location: VenueLocation;
  media: VenueMedia;
  dailyUpdate: DailyUpdate | null;
  stats: VenueStats;
  tags: string[];
  ownerId: string;
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

export interface MenuItem {
  id: string;
  name: string;
  description: string | null;
  price: number | null;
  imageUrl: string | null;
  category: string;
  isAvailable: boolean;
  order: number;
  createdAt: Timestamp;
}

export interface Service {
  id: string;
  name: string;
  description: string | null;
  price: number | null;
  duration: number | null; // minutos, para citas en v2
  imageUrl: string | null;
  isAvailable: boolean;
  order: number;
  createdAt: Timestamp;
}

export interface Owner {
  id: string;
  displayName: string;
  email: string;
  phone: string;
  venueIds: string[];
  createdAt: Timestamp;
  updatedAt: Timestamp;
}

// Venue con distancia calculada (para el feed del consumidor)
export interface VenueWithDistance extends Venue {
  distanceKm: number;
}
