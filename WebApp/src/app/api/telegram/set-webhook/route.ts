import { NextRequest, NextResponse } from "next/server";

// Llama este endpoint una sola vez después de hacer deploy en Vercel
// GET /api/telegram/set-webhook
export async function GET(req: NextRequest) {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  if (!token) return NextResponse.json({ error: "TELEGRAM_BOT_TOKEN no configurado" }, { status: 500 });

  const host = req.headers.get("host");
  const protocol = host?.includes("localhost") ? "http" : "https";
  const webhookUrl = `${protocol}://${host}/api/telegram/webhook`;

  const res = await fetch(`https://api.telegram.org/bot${token}/setWebhook`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ url: webhookUrl, allowed_updates: ["message"] }),
  });

  const data = await res.json();
  return NextResponse.json({ webhookUrl, telegram: data });
}
