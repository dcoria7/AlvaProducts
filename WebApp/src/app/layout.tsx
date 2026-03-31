import type { Metadata } from "next";
import { Geist } from "next/font/google";
import { BottomNav } from "@/components/layout/BottomNav";
import "./globals.css";

const geist = Geist({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "ClickLocal – Negocios cerca de ti",
  description: "Descubre negocios locales, a puerta cerrada y ambulantes cerca de ti.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body className={`${geist.className} antialiased bg-gray-50`}>
        {children}
        <BottomNav />
      </body>
    </html>
  );
}
