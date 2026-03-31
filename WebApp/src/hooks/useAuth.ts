"use client";

import { useEffect, useState } from "react";
import { User } from "firebase/auth";
import { onAuthChange, getOwnerProfile } from "@/services/auth";
import { Owner } from "@/types";

export function useAuth() {
  const [user, setUser] = useState<User | null>(null);
  const [owner, setOwner] = useState<Owner | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthChange(async (firebaseUser) => {
      setUser(firebaseUser);
      if (firebaseUser) {
        const profile = await getOwnerProfile(firebaseUser.uid);
        setOwner(profile);
      } else {
        setOwner(null);
      }
      setLoading(false);
    });
    return () => unsubscribe();
  }, []);

  return { user, owner, loading };
}
