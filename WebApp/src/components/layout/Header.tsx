import Link from "next/link";
import { MapPin } from "lucide-react";

interface HeaderProps {
  subtitle?: string;
}

export function Header({ subtitle }: HeaderProps) {
  return (
    <header className="sticky top-0 z-10 bg-white/80 backdrop-blur-sm border-b border-gray-100">
      <div className="max-w-lg mx-auto px-4 py-3 flex items-center justify-between">
        <div>
          <Link href="/" className="flex items-center gap-1.5">
            <MapPin className="w-5 h-5 text-emerald-500" />
            <span className="font-bold text-gray-900 text-lg">ClickLocal</span>
          </Link>
          {subtitle && (
            <p className="text-xs text-gray-400 mt-0.5">{subtitle}</p>
          )}
        </div>
        <Link
          href="/dashboard"
          className="text-xs text-gray-500 hover:text-gray-900 transition-colors"
        >
          Soy negocio →
        </Link>
      </div>
    </header>
  );
}
