import {
  collection,
  doc,
  getDocs,
  getDoc,
  addDoc,
  updateDoc,
  query,
  where,
  orderBy,
  serverTimestamp,
  increment,
  GeoPoint,
} from "firebase/firestore";
import { db } from "@/lib/firebase";
import { Venue, MenuItem, Service, VenueWithDistance } from "@/types";

const VENUES_COLLECTION = "venues";

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

export async function getActiveVenues(): Promise<Venue[]> {
  const q = query(
    collection(db, VENUES_COLLECTION),
    where("isActive", "==", true),
    orderBy("statusUpdatedAt", "desc")
  );
  const snapshot = await getDocs(q);
  return snapshot.docs.map((d) => ({ id: d.id, ...d.data() } as Venue));
}

export async function getVenuesSortedByDistance(
  userLat: number,
  userLon: number,
  radiusKm = 20
): Promise<VenueWithDistance[]> {
  const venues = await getActiveVenues();
  return venues
    .map((v) => {
      const { latitude, longitude } = v.location.coordinates;
      const distanceKm = haversineKm(userLat, userLon, latitude, longitude);
      return { ...v, distanceKm };
    })
    .filter((v) => v.distanceKm <= radiusKm)
    .sort((a, b) => a.distanceKm - b.distanceKm);
}

export async function getVenueById(venueId: string): Promise<Venue | null> {
  const ref = doc(db, VENUES_COLLECTION, venueId);
  const snap = await getDoc(ref);
  if (!snap.exists()) return null;
  return { id: snap.id, ...snap.data() } as Venue;
}

export async function getMenuItems(venueId: string): Promise<MenuItem[]> {
  const q = query(
    collection(db, VENUES_COLLECTION, venueId, "menuItems"),
    where("isAvailable", "==", true),
    orderBy("order", "asc")
  );
  const snapshot = await getDocs(q);
  return snapshot.docs.map((d) => ({ id: d.id, ...d.data() } as MenuItem));
}

export async function getServices(venueId: string): Promise<Service[]> {
  const q = query(
    collection(db, VENUES_COLLECTION, venueId, "services"),
    where("isAvailable", "==", true),
    orderBy("order", "asc")
  );
  const snapshot = await getDocs(q);
  return snapshot.docs.map((d) => ({ id: d.id, ...d.data() } as Service));
}

export async function incrementVenueViews(venueId: string): Promise<void> {
  const ref = doc(db, VENUES_COLLECTION, venueId);
  await updateDoc(ref, { "stats.views": increment(1) });
}

export async function incrementWhatsappTaps(venueId: string): Promise<void> {
  const ref = doc(db, VENUES_COLLECTION, venueId);
  await updateDoc(ref, { "stats.whatsappTaps": increment(1) });
}

export async function createVenue(
  ownerId: string,
  data: Omit<Venue, "id" | "createdAt" | "updatedAt" | "stats" | "statusUpdatedAt">
): Promise<string> {
  const ref = await addDoc(collection(db, VENUES_COLLECTION), {
    ...data,
    ownerId,
    stats: { views: 0, whatsappTaps: 0 },
    statusUpdatedAt: serverTimestamp(),
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });
  return ref.id;
}

export async function updateVenue(
  venueId: string,
  data: Partial<Omit<Venue, "id" | "createdAt" | "ownerId">>
): Promise<void> {
  const ref = doc(db, VENUES_COLLECTION, venueId);
  await updateDoc(ref, { ...data, updatedAt: serverTimestamp() });
}

export async function isBotPhoneUnique(botPhone: string, excludeVenueId?: string): Promise<boolean> {
  const q = query(
    collection(db, VENUES_COLLECTION),
    where("contact.botPhone", "==", botPhone)
  );
  const snapshot = await getDocs(q);
  if (snapshot.empty) return true;
  if (excludeVenueId && snapshot.docs.length === 1 && snapshot.docs[0].id === excludeVenueId) return true;
  return false;
}

export async function getVenuesByOwner(ownerId: string): Promise<Venue[]> {
  const q = query(
    collection(db, VENUES_COLLECTION),
    where("ownerId", "==", ownerId)
  );
  const snapshot = await getDocs(q);
  return snapshot.docs.map((d) => ({ id: d.id, ...d.data() } as Venue));
}

// Venues con dailyUpdate reciente para el feed social
export async function getFeedVenues(): Promise<Venue[]> {
  const q = query(
    collection(db, VENUES_COLLECTION),
    where("isActive", "==", true),
    orderBy("dailyUpdate.updatedAt", "desc")
  );
  const snapshot = await getDocs(q);
  return snapshot.docs
    .map((d) => ({ id: d.id, ...d.data() } as Venue))
    .filter((v) => v.dailyUpdate?.text || v.dailyUpdate?.imageUrl);
}
