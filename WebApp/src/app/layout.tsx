import type { Metadata } from "next";
import { Geist } from "next/font/google";
import "./globals.css";

const geist = Geist({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "AlvaProducts – Negocios cerca de ti",
  description: "Descubre negocios locales, a puerta cerrada y ambulantes cerca de ti.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es">
      <body className={`${geist.className} antialiased`}>{children}</body>
    </html>
  );
}
