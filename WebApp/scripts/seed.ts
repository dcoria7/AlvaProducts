import { initializeApp, cert, getApps } from "firebase-admin/app";
import { getFirestore, Timestamp, GeoPoint } from "firebase-admin/firestore";
import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

// Lee el service account desde variable de entorno o archivo
const serviceAccountPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
if (!serviceAccountPath) {
  console.error(`
❌ Falta la variable de entorno GOOGLE_APPLICATION_CREDENTIALS

Para ejecutar el script:
1. Ve a Firebase Console → Configuración del proyecto → Cuentas de servicio
2. Haz clic en "Generar nueva clave privada" y descarga el archivo JSON
3. Ejecuta el script así:

   GOOGLE_APPLICATION_CREDENTIALS=/ruta/al/archivo.json npx tsx scripts/seed.ts
`);
  process.exit(1);
}

const serviceAccount = JSON.parse(readFileSync(serviceAccountPath, "utf8"));

if (getApps().length === 0) {
  initializeApp({ credential: cert(serviceAccount) });
}

const db = getFirestore();
const data = JSON.parse(
  readFileSync(join(__dirname, "seed-data.json"), "utf8")
);

async function seed() {
  console.log(`\n🌱 Iniciando seed en proyecto: ${serviceAccount.project_id}\n`);

  for (const venue of data.venues) {
    const { menuItems, services, dailyUpdate, location, ...venueData } = venue;

    // Construye el documento del venue
    const venueDoc = {
      ...venueData,
      location: {
        ...location,
        coordinates: new GeoPoint(location.coordinates.lat, location.coordinates.lng),
      },
      dailyUpdate: dailyUpdate
        ? { ...dailyUpdate, updatedAt: Timestamp.now() }
        : null,
      stats: { views: 0, whatsappTaps: 0 },
      ownerId: "seed-owner",
      statusUpdatedAt: Timestamp.now(),
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    };

    const venueRef = await db.collection("venues").add(venueDoc);
    console.log(`✅ Venue creado: "${venue.name}" → ${venueRef.id}`);

    // Inserta menuItems si los tiene
    if (menuItems?.length) {
      for (const item of menuItems) {
        await venueRef.collection("menuItems").add({
          ...item,
          imageUrl: null,
          createdAt: Timestamp.now(),
        });
      }
      console.log(`   📋 ${menuItems.length} items de menú insertados`);
    }

    // Inserta services si los tiene
    if (services?.length) {
      for (const service of services) {
        await venueRef.collection("services").add({
          ...service,
          imageUrl: null,
          createdAt: Timestamp.now(),
        });
      }
      console.log(`   🔧 ${services.length} servicios insertados`);
    }
  }

  console.log(`\n🎉 Seed completado: ${data.venues.length} negocios insertados\n`);
}

seed().catch((err) => {
  console.error("❌ Error durante el seed:", err);
  process.exit(1);
});
