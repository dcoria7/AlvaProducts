import { createClient } from "@supabase/supabase-js";
import { readFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseServiceKey) {
  console.error(`
❌ Faltan variables de entorno

Ejecuta el script así:
  NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co \\
  SUPABASE_SERVICE_ROLE_KEY=tu-service-role-key \\
  npx tsx scripts/seed.ts

Encuentra estos valores en:
  Supabase Console → Project Settings → API
`);
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseServiceKey);
const data = JSON.parse(readFileSync(join(__dirname, "seed-data.json"), "utf8"));

async function seed() {
  console.log(`\n🌱 Iniciando seed en: ${supabaseUrl}\n`);

  // Limpiar datos existentes (en orden por foreign keys)
  await supabase.from("menu_items").delete().neq("id", "00000000-0000-0000-0000-000000000000");
  await supabase.from("services").delete().neq("id", "00000000-0000-0000-0000-000000000000");
  await supabase.from("venues").delete().neq("id", "00000000-0000-0000-0000-000000000000");
  console.log("🗑️  Datos anteriores eliminados\n");

  for (const venue of data.venues) {
    const { menuItems, services, dailyUpdate, location, contact, media, ...rest } = venue;

    const { data: inserted, error } = await supabase
      .from("venues")
      .insert({
        name: rest.name,
        type: rest.type,
        description: rest.description,
        status: rest.status,
        is_active: rest.isActive,
        tags: rest.tags,
        owner_id: "seed-owner",
        phone: contact.phone,
        bot_phone: contact.botPhone,
        instagram: contact.instagram ?? null,
        lat: location.coordinates.lat,
        lng: location.coordinates.lng,
        location_reference: location.reference,
        address: location.address ?? null,
        is_ambulatory: location.isAmbulatory,
        logo_url: media.logoUrl ?? null,
        cover_url: media.coverUrl ?? null,
        daily_text: dailyUpdate?.text ?? null,
        daily_image_url: dailyUpdate?.imageUrl ?? null,
        daily_updated_at: dailyUpdate ? new Date().toISOString() : null,
        status_updated_at: new Date().toISOString(),
      })
      .select("id")
      .single();

    if (error) { console.error(`❌ Error insertando "${rest.name}":`, error.message); continue; }

    console.log(`✅ Venue: "${rest.name}" → ${inserted.id}`);

    if (menuItems?.length) {
      const { error: menuError } = await supabase.from("menu_items").insert(
        menuItems.map((item: Record<string, unknown>, idx: number) => ({
          venue_id: inserted.id,
          name: item.name,
          description: item.description ?? null,
          price: item.price ?? null,
          category: item.category,
          is_available: item.isAvailable ?? true,
          order: item.order ?? idx,
          image_url: null,
        }))
      );
      if (menuError) console.error(`   ❌ Error en menuItems:`, menuError.message);
      else console.log(`   📋 ${menuItems.length} items de menú`);
    }

    if (services?.length) {
      const { error: svcError } = await supabase.from("services").insert(
        services.map((s: Record<string, unknown>, idx: number) => ({
          venue_id: inserted.id,
          name: s.name,
          description: s.description ?? null,
          price: s.price ?? null,
          duration: s.duration ?? null,
          is_available: s.isAvailable ?? true,
          order: s.order ?? idx,
          image_url: null,
        }))
      );
      if (svcError) console.error(`   ❌ Error en services:`, svcError.message);
      else console.log(`   🔧 ${services.length} servicios`);
    }
  }

  console.log(`\n🎉 Seed completado: ${data.venues.length} negocios\n`);
}

seed().catch((err) => { console.error("❌ Error:", err); process.exit(1); });
