// Auth is handled entirely by Clerk.
// This file contains only Supabase profile operations for venue owners.

import { supabase } from "@/lib/supabase";
import { Owner } from "@/types";

const OWNERS_TABLE = "owners";

export async function getOwnerProfile(clerkUserId: string): Promise<Owner | null> {
  const { data, error } = await supabase
    .from(OWNERS_TABLE)
    .select("*")
    .eq("id", clerkUserId)
    .single();

  if (error || !data) return null;
  return {
    id: data.id,
    display_name: data.display_name,
    email: data.email,
    phone: data.phone ?? "",
    venue_ids: data.venue_ids ?? [],
    created_at: data.created_at,
    updated_at: data.updated_at,
  };
}

export async function upsertOwnerProfile(
  clerkUserId: string,
  profile: { display_name: string; email: string; phone?: string }
): Promise<void> {
  const { error } = await supabase.from(OWNERS_TABLE).upsert({
    id: clerkUserId,
    display_name: profile.display_name,
    email: profile.email,
    phone: profile.phone ?? "",
    updated_at: new Date().toISOString(),
  });
  if (error) throw new Error(error.message);
}

export async function addVenueToOwner(clerkUserId: string, venueId: string): Promise<void> {
  const profile = await getOwnerProfile(clerkUserId);
  const current = profile?.venue_ids ?? [];
  if (current.includes(venueId)) return;
  const { error } = await supabase
    .from(OWNERS_TABLE)
    .update({ venue_ids: [...current, venueId], updated_at: new Date().toISOString() })
    .eq("id", clerkUserId);
  if (error) throw new Error(error.message);
}
