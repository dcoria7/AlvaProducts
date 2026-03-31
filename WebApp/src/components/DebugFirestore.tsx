"use client";

import { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "@/lib/firebase";

export function DebugFirestore() {
  const [result, setResult] = useState<string>("Consultando Firestore...");

  useEffect(() => {
    async function check() {
      try {
        const snapshot = await getDocs(collection(db, "venues"));
        if (snapshot.empty) {
          setResult("⚠️ Colección venues existe pero está vacía o no existe");
        } else {
          const names = snapshot.docs.map((d) => {
            const data = d.data();
            return `• ${data.name} (isActive: ${data.isActive}, status: ${data.status})`;
          });
          setResult(`✅ ${snapshot.docs.length} venues encontrados:\n${names.join("\n")}`);
        }
      } catch (err: unknown) {
        setResult(`❌ Error: ${err instanceof Error ? err.message : String(err)}`);
      }
    }
    check();
  }, []);

  return (
    <div className="mx-4 my-3 p-3 bg-yellow-50 border border-yellow-200 rounded-xl">
      <p className="text-xs font-bold text-yellow-700 mb-1">Debug Firestore</p>
      <pre className="text-xs text-yellow-800 whitespace-pre-wrap">{result}</pre>
    </div>
  );
}
