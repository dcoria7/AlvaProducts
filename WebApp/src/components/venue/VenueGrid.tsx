"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { Venue, VenueType } from "@/types";
import { getActiveVenues } from "@/services/venues";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { UtensilsCrossed, Wrench, Layers, Loader2, SlidersHorizontal } from "lucide-react";

type FilterType = "all" | VenueType;

const TYPE_FILTERS: { value: FilterType; label: string }[] = [
  { value: "all", label: "Todos" },
  { value: "food", label: "Comida" },
  { value: "service", label: "Servicios" },
  { value: "both", label: "Mixtos" },
];

const TYPE_ICON = {
  food: UtensilsCrossed,
  service: Wrench,
  both: Layers,
};

function VenueGridCard({ venue }: { venue: Venue }) {
  const Icon = TYPE_ICON[venue.type];
  const isOpen = venue.status === "open";

  return (
    <Link
      href={`/venue/${venue.id}`}
      className={`relative flex flex-col rounded-2xl overflow-hidden border transition-transform active:scale-95 ${
        isOpen ? "border-gray-100 bg-white" : "border-gray-100 bg-white opacity-60"
      }`}
    >
      {/* Imagen / Logo */}
      <div className="relative w-full aspect-square bg-gray-100">
        {venue.media.logoUrl ? (
          <Image
            src={venue.media.logoUrl}
            alt={venue.name}
            fill
            className="object-cover"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center bg-gradient-to-br from-gray-50 to-gray-100">
            <Icon className="w-10 h-10 text-gray-300" />
          </div>
        )}

        {/* Badge de estado encima de la imagen */}
        <div className="absolute top-2 left-2">
          <span
            className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-semibold ${
              isOpen
                ? "bg-emerald-500 text-white"
                : "bg-gray-800/70 text-white"
            }`}
          >
            <span className={`w-1.5 h-1.5 rounded-full bg-white ${isOpen ? "animate-pulse" : "opacity-60"}`} />
            {isOpen ? "Abierto" : "Cerrado"}
          </span>
        </div>
      </div>

      {/* Info */}
      <div className="p-2.5">
        <p className="font-semibold text-gray-900 text-sm truncate">{venue.name}</p>
        <p className="text-xs text-gray-400 truncate mt-0.5">{venue.location.reference}</p>
        {venue.location.isAmbulatory && (
          <span className="text-[10px] text-amber-600 font-medium">Ambulante</span>
        )}
      </div>
    </Link>
  );
}

function GridSection({ title, venues, accent }: { title: string; venues: Venue[]; accent: string }) {
  if (venues.length === 0) return null;
  return (
    <section>
      <h2 className={`text-base font-bold mb-3 ${accent}`}>{title}</h2>
      <div className="grid grid-cols-2 gap-3">
        {venues.map((v) => (
          <VenueGridCard key={v.id} venue={v} />
        ))}
      </div>
    </section>
  );
}

export function VenueGrid() {
  const [venues, setVenues] = useState<Venue[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeFilter, setActiveFilter] = useState<FilterType>("all");

  useEffect(() => {
    getActiveVenues().then((data) => {
      setVenues(data);
      setLoading(false);
    });
  }, []);

  const filtered = venues.filter(
    (v) => activeFilter === "all" || v.type === activeFilter || (activeFilter !== "both" && v.type === "both")
  );

  const open = filtered.filter((v) => v.status === "open");
  const closed = filtered.filter((v) => v.status === "closed");

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <Loader2 className="w-8 h-8 animate-spin text-gray-300" />
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      {/* Filtros */}
      <div className="flex items-center gap-2">
        <SlidersHorizontal className="w-4 h-4 text-gray-400 shrink-0" />
        <div className="flex gap-2 overflow-x-auto pb-1">
          {TYPE_FILTERS.map((f) => (
            <button
              key={f.value}
              onClick={() => setActiveFilter(f.value)}
              className={`shrink-0 px-3 py-1.5 rounded-full text-sm font-medium transition-colors ${
                activeFilter === f.value
                  ? "bg-gray-900 text-white"
                  : "bg-gray-100 text-gray-600 hover:bg-gray-200"
              }`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {filtered.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 text-gray-400 gap-2">
          <p className="text-sm">No hay negocios con ese filtro</p>
        </div>
      ) : (
        <>
          <GridSection title="Abiertos" venues={open} accent="text-emerald-600" />
          <GridSection title="Cerrados" venues={closed} accent="text-gray-400" />
        </>
      )}
    </div>
  );
}
