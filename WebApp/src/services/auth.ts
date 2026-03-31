import {
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  signOut as firebaseSignOut,
  onAuthStateChanged,
  User,
  updateProfile,
} from "firebase/auth";
import { doc, setDoc, getDoc, updateDoc, serverTimestamp } from "firebase/firestore";
import { auth, db } from "@/lib/firebase";
import { Owner } from "@/types";

const USERS_COLLECTION = "users";

export async function registerOwner(
  email: string,
  password: string,
  displayName: string,
  phone: string
): Promise<User> {
  const credential = await createUserWithEmailAndPassword(auth, email, password);
  await updateProfile(credential.user, { displayName });
  await setDoc(doc(db, USERS_COLLECTION, credential.user.uid), {
    displayName,
    email,
    phone,
    venueIds: [],
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });
  return credential.user;
}

export async function signIn(email: string, password: string): Promise<User> {
  const credential = await signInWithEmailAndPassword(auth, email, password);
  return credential.user;
}

export async function signOut(): Promise<void> {
  await firebaseSignOut(auth);
}

export async function getOwnerProfile(uid: string): Promise<Owner | null> {
  const snap = await getDoc(doc(db, USERS_COLLECTION, uid));
  if (!snap.exists()) return null;
  return { id: snap.id, ...snap.data() } as Owner;
}

export async function addVenueToOwner(uid: string, venueId: string): Promise<void> {
  const ref = doc(db, USERS_COLLECTION, uid);
  const snap = await getDoc(ref);
  if (!snap.exists()) return;
  const current = snap.data().venueIds ?? [];
  await updateDoc(ref, {
    venueIds: [...current, venueId],
    updatedAt: serverTimestamp(),
  });
}

export function onAuthChange(callback: (user: User | null) => void) {
  return onAuthStateChanged(auth, callback);
}
