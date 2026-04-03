import { NextRequest, NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";
import { sendMessage, getFile } from "@/lib/telegram";

// Cliente con service role para operaciones del servidor
const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);

interface TelegramMessage {
  message_id: number;
  from: { id: number; first_name: string };
  chat: { id: number };
  text?: string;
  photo?: { file_id: string; file_size: number }[];
  caption?: string;
}

interface TelegramUpdate {
  update_id: number;
  message?: TelegramMessage;
}

async function getVenueByChatId(chatId: string) {
  const { data } = await supabase
    .from("venues")
    .select("*")
    .eq("telegram_chat_id", chatId)
    .single();
  return data;
}

async function uploadPhotoToSupabase(fileUrl: string, venueId: string): Promise<string | null> {
  try {
    const res = await fetch(fileUrl);
    const buffer = await res.arrayBuffer();
    const fileName = `venues/${venueId}/daily-${Date.now()}.jpg`;

    const { error } = await supabase.storage
      .from("venue-media")
      .upload(fileName, buffer, { contentType: "image/jpeg", upsert: true });

    if (error) return null;

    const { data } = supabase.storage.from("venue-media").getPublicUrl(fileName);
    return data.publicUrl;
  } catch {
    return null;
  }
}

async function handleMessage(message: TelegramMessage) {
  const chatId = message.chat.id.toString();
  const text = message.text?.trim().toLowerCase() ?? "";
  const firstName = message.from.first_name;

  // Comando /start — muestra chat_id para que el admin lo configure
  if (text === "/start") {
    await sendMessage(chatId,
      `👋 Hola <b>${firstName}</b>, bienvenido al bot de ClickLocal.\n\n` +
      `Tu Chat ID es: <code>${chatId}</code>\n\n` +
      `Comparte este número con el administrador para vincular tu negocio.\n\n` +
      `Una vez vinculado podrás usar:\n` +
      `• <b>abierto</b> o <b>cerrado</b>\n` +
      `• <b>menu: texto</b> — actualizar menú del día\n` +
      `• <b>tel: número</b> — cambiar teléfono\n` +
      `• Enviar una <b>foto</b> — imagen del menú del día\n` +
      `• <b>info</b> — ver estado actual`
    );
    return;
  }

  // Buscar venue vinculado a este chat_id
  const venue = await getVenueByChatId(chatId);

  if (!venue) {
    await sendMessage(chatId,
      `❌ Este número no está vinculado a ningún negocio.\n\n` +
      `Comparte tu Chat ID con el administrador: <code>${chatId}</code>`
    );
    return;
  }

  // ── Comando: abierto ────────────────────────────────────
  if (text === "abierto" || text === "open") {
    await supabase.from("venues").update({
      status: "open",
      status_updated_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }).eq("id", venue.id);

    await sendMessage(chatId,
      `✅ <b>${venue.name}</b> ahora aparece como <b>Abierto</b> en ClickLocal.`
    );
    return;
  }

  // ── Comando: cerrado ─────────────────────────────────────
  if (text === "cerrado" || text === "closed") {
    await supabase.from("venues").update({
      status: "closed",
      status_updated_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }).eq("id", venue.id);

    await sendMessage(chatId,
      `🔴 <b>${venue.name}</b> ahora aparece como <b>Cerrado</b> en ClickLocal.`
    );
    return;
  }

  // ── Comando: info ─────────────────────────────────────────
  if (text === "info") {
    const statusEmoji = venue.status === "open" ? "🟢" : "🔴";
    const statusLabel = venue.status === "open" ? "Abierto" : "Cerrado";
    await sendMessage(chatId,
      `📊 <b>${venue.name}</b>\n\n` +
      `Estado: ${statusEmoji} ${statusLabel}\n` +
      `Teléfono: ${venue.phone}\n` +
      `Vistas: ${venue.views}\n` +
      `Taps WhatsApp: ${venue.whatsapp_taps}\n\n` +
      `${venue.daily_text ? `Menú del día: ${venue.daily_text}` : "Sin menú del día"}`
    );
    return;
  }

  // ── Comando: menu: texto ──────────────────────────────────
  const menuMatch = message.text?.match(/^menu:\s*([\s\S]+)/i);
  if (menuMatch) {
    const menuText = menuMatch[1].trim();
    await supabase.from("venues").update({
      daily_text: menuText,
      daily_updated_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }).eq("id", venue.id);

    await sendMessage(chatId,
      `📋 Menú del día actualizado en <b>${venue.name}</b>:\n\n"${menuText}"`
    );
    return;
  }

  // ── Comando: tel: número ──────────────────────────────────
  const telMatch = message.text?.match(/^tel:\s*(\+?[\d\s\-]+)/i);
  if (telMatch) {
    const newPhone = telMatch[1].replace(/\s/g, "");
    await supabase.from("venues").update({
      phone: newPhone,
      updated_at: new Date().toISOString(),
    }).eq("id", venue.id);

    await sendMessage(chatId,
      `📱 Teléfono actualizado en <b>${venue.name}</b>: ${newPhone}`
    );
    return;
  }

  // ── Foto — imagen del menú del día ────────────────────────
  if (message.photo) {
    const largest = message.photo[message.photo.length - 1];
    const fileUrl = await getFile(largest.file_id);

    if (!fileUrl) {
      await sendMessage(chatId, "❌ No se pudo obtener la foto. Intenta de nuevo.");
      return;
    }

    const publicUrl = await uploadPhotoToSupabase(fileUrl, venue.id);

    if (!publicUrl) {
      await sendMessage(chatId, "❌ Error al subir la foto. Verifica que Supabase Storage esté configurado.");
      return;
    }

    const caption = message.caption?.trim() ?? null;
    await supabase.from("venues").update({
      daily_image_url: publicUrl,
      daily_text: caption ?? venue.daily_text,
      daily_updated_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    }).eq("id", venue.id);

    await sendMessage(chatId,
      `📸 Foto del menú actualizada en <b>${venue.name}</b>.` +
      (caption ? `\n\n"${caption}"` : "")
    );
    return;
  }

  // ── Comando no reconocido ─────────────────────────────────
  await sendMessage(chatId,
    `❓ No entendí ese comando. Puedes usar:\n\n` +
    `• <b>abierto</b> / <b>cerrado</b>\n` +
    `• <b>menu:</b> texto del menú del día\n` +
    `• <b>tel:</b> nuevo número\n` +
    `• Enviar una <b>foto</b> para el menú del día\n` +
    `• <b>info</b> para ver el estado actual`
  );
}

// POST — recibe updates de Telegram
export async function POST(req: NextRequest) {
  try {
    const update: TelegramUpdate = await req.json();
    if (update.message) await handleMessage(update.message);
    return NextResponse.json({ ok: true });
  } catch (err) {
    console.error("Telegram webhook error:", err);
    return NextResponse.json({ ok: false }, { status: 500 });
  }
}

// GET — verifica que el webhook esté activo
export async function GET() {
  return NextResponse.json({ ok: true, service: "ClickLocal Telegram Bot" });
}
