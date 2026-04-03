"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Newspaper, LayoutGrid } from "lucide-react";

const NAV_ITEMS = [
  { href: "/", label: "Feed", icon: Newspaper },
  { href: "/negocios", label: "Negocios", icon: LayoutGrid },
];

export function BottomNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-20 bg-white border-t border-gray-100 safe-area-pb">
      <div className="max-w-lg mx-auto flex">
        {NAV_ITEMS.map(({ href, label, icon: Icon }) => {
          const isActive = pathname === href;
          return (
            <Link
              key={href}
              href={href}
              className={`flex-1 flex flex-col items-center justify-center py-3 gap-1 transition-colors ${
                isActive ? "text-emerald-600" : "text-gray-400 hover:text-gray-600"
              }`}
            >
              <Icon className={`w-5 h-5 ${isActive ? "stroke-[2.5px]" : ""}`} />
              <span className="text-[11px] font-medium">{label}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
