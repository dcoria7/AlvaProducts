"use client";

import { useEffect, useState } from "react";
import { VenueWithDistance, VenueType, VenueStatus } from "@/types";
import { getVenuesSortedByDistance, getActiveVenues } from "@/services/venues";
import { useGeolocation } from "@/hooks/useGeolocation";
import { VenueCard } from "./VenueCard";
import { FilterTabs } from "@/components/ui/FilterTabs";
import { MapPin, Loader2, AlertCircle } from "lucide-react";

type FilterType = "all" | VenueType;
type FilterStatus = "all" | VenueStatus;

export function VenueFeed() {
  const { coordinates, error: geoError, loading: geoLoading } = useGeolocation();
  const [venues, setVenues] = useState<VenueWithDistance[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeType, setActiveType] = useState<FilterType>("all");
  const [activeStatus, setActiveStatus] = useState<FilterStatus>("all");

  useEffect(() => {
    if (geoLoading) return;

    async function fetchVenues() {
      try {
        setLoading(true);
        if (coordinates) {
          const data = await getVenuesSortedByDistance(
            coordinates.lat,
            coordinates.lon,
            50
          );
          setVenues(data);
        } else {
          // Sin ubicación: carga todos igual pero sin distancia
          const data = await getActiveVenues();
          setVenues(data.map((v) => ({ ...v, distanceKm: Infinity })));
        }
      } catch {
        setError("No se pudieron cargar los negocios. Intenta de nuevo.");
      } finally {
        setLoading(false);
      }
    }

    fetchVenues();
  }, [coordinates, geoLoading]);

  const filtered = venues.filter((v) => {
    const typeMatch = activeType === "all" || v.type === activeType || v.type === "both";
    const statusMatch = activeStatus === "all" || v.status === activeStatus;
    return typeMatch && statusMatch;
  });

  const openCount = venues.filter((v) => v.status === "open").length;

  return (
    <div className="flex flex-col gap-4">
      {/* Location info */}
      <div className="flex items-center gap-2 text-sm text-gray-500">
        <MapPin className="w-4 h-4 shrink-0" />
        {geoLoading ? (
          <span>Obteniendo tu ubicación...</span>
        ) : geoError ? (
          <span className="text-amber-600">{geoError} · Mostrando todos los negocios</span>
        ) : (
          <span>
            {openCount > 0 ? (
              <><span className="text-emerald-600 font-medium">{openCount} abiertos</span> cerca de ti</>
            ) : (
              "Negocios cerca de ti"
            )}
          </span>
        )}
      </div>

      {/* Filters */}
      <FilterTabs
        activeType={activeType}
        activeStatus={activeStatus}
        onTypeChange={setActiveType}
        onStatusChange={setActiveStatus}
      />

      {/* List */}
      {loading ? (
        <div className="flex flex-col items-center justify-center py-20 gap-3 text-gray-400">
          <Loader2 className="w-8 h-8 animate-spin" />
          <span className="text-sm">Buscando negocios...</span>
        </div>
      ) : error ? (
        <div className="flex flex-col items-center justify-center py-20 gap-3 text-gray-400">
          <AlertCircle className="w-8 h-8 text-red-400" />
          <span className="text-sm text-red-500">{error}</span>
        </div>
      ) : filtered.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-20 gap-2 text-gray-400">
          <MapPin className="w-10 h-10" />
          <p className="text-sm font-medium">No hay negocios con ese filtro</p>
          <p className="text-xs text-gray-300">Prueba cambiando el filtro o el radio de búsqueda</p>
        </div>
      ) : (
        <div className="flex flex-col gap-3">
          {filtered.map((venue) => (
            <VenueCard key={venue.id} venue={venue} />
          ))}
        </div>
      )}
    </div>
  );
}
