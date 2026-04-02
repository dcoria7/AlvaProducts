"use client";

import { useUser } from "@clerk/nextjs";
import { useEffect, useState } from "react";
import { getOwnerProfile } from "@/services/auth";
import { Owner } from "@/types";

export function useAuth() {
  const { user, isLoaded } = useUser();
  const [owner, setOwner] = useState<Owner | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!isLoaded) return;
    if (!user) { setOwner(null); setLoading(false); return; }

    getOwnerProfile(user.id)
      .then(setOwner)
      .finally(() => setLoading(false));
  }, [user, isLoaded]);

  return { user, owner, loading };
}
