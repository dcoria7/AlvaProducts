"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { Venue, VenueWithDistance } from "@/types";
import { getVenuesSortedByDistance, getActiveVenues, incrementWhatsappTaps } from "@/services/venues";
import { useGeolocation } from "@/hooks/useGeolocation";
import { MessageCircle, Loader2, MapPin, Navigation } from "lucide-react";
import { StatusBadge } from "@/components/ui/StatusBadge";

const RADIUS_OPTIONS = [
  { label: "1 km", value: 1 },
  { label: "5 km", value: 5 },
  { label: "10 km", value: 10 },
  { label: "Todos", value: 9999 },
];

function timeAgo(isoString: string): string {
  const diff = Math.floor((Date.now() - new Date(isoString).getTime()) / 1000);
  if (diff < 60) return "ahora";
  if (diff < 3600) return `hace ${Math.floor(diff / 60)} min`;
  if (diff < 86400) return `hace ${Math.floor(diff / 3600)} h`;
  return `hace ${Math.floor(diff / 86400)} d`;
}

function GridCard({ venue }: { venue: VenueWithDistance | Venue }) {
  const isOpen = venue.status === "open";
  return (
    <Link href={`/venue/${venue.id}`} className={`relative flex flex-col rounded-2xl overflow-hidden border border-gray-100 bg-white active:scale-95 transition-transform ${!isOpen ? "opacity-55" : ""}`}>
      <div className="relative w-full aspect-square bg-gray-100">
        {venue.media.logo_url ? (
          <Image src={venue.media.logo_url} alt={venue.name} fill sizes="(max-width: 768px) 33vw, 200px" className="object-cover" />
        ) : (
          <div className="w-full h-full flex items-center justify-center bg-gradient-to-br from-gray-50 to-gray-100">
            <span className="text-2xl font-bold text-gray-200">{venue.name[0]}</span>
          </div>
        )}
        <span className={`absolute top-2 left-2 inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] font-semibold ${isOpen ? "bg-emerald-500 text-white" : "bg-black/50 text-white"}`}>
          <span className={`w-1.5 h-1.5 rounded-full bg-white ${isOpen ? "animate-pulse" : "opacity-60"}`} />
          {isOpen ? "Abierto" : "Cerrado"}
        </span>
      </div>
      <div className="px-2.5 py-2">
        <p className="font-semibold text-gray-900 text-sm truncate">{venue.name}</p>
        <p className="text-xs text-gray-400 truncate">{venue.location.reference}</p>
        {"distance_km" in venue && venue.distance_km < 9999 && (
          <p className="text-xs text-emerald-600 mt-0.5">
            {venue.distance_km < 1 ? `${Math.round(venue.distance_km * 1000)} m` : `${venue.distance_km.toFixed(1)} km`}
          </p>
        )}
      </div>
    </Link>
  );
}

function FeedCard({ venue }: { venue: VenueWithDistance | Venue }) {
  const update = venue.daily_update!;
  const phone = venue.contact.phone.replace(/\D/g, "");

  async function handleWhatsApp() {
    await incrementWhatsappTaps(venue.id);
    window.open(`https://wa.me/${phone}`, "_blank");
  }

  return (
    <article className="bg-white border-b border-gray-100">
      <Link href={`/venue/${venue.id}`} className="flex items-center gap-3 px-4 py-3">
        <div className="relative w-9 h-9 rounded-full overflow-hidden bg-emerald-50 shrink-0">
          {venue.media.logo_url ? (
            <Image src={venue.media.logo_url} alt={venue.name} fill sizes="40px" className="object-cover" />
          ) : (
            <div className="w-full h-full flex items-center justify-center">
              <span className="text-sm font-bold text-emerald-400">{venue.name[0]}</span>
            </div>
          )}
        </div>
        <div className="flex-1 min-w-0">
          <p className="font-semibold text-gray-900 text-sm">{venue.name}</p>
          <div className="flex items-center gap-2">
            <StatusBadge status={venue.status} />
            {update.updated_at && <span className="text-xs text-gray-400">{timeAgo(update.updated_at)}</span>}
          </div>
        </div>
      </Link>

      {update.image_url && (
        <Link href={`/venue/${venue.id}`} className="block relative w-full aspect-square">
          <Image src={update.image_url} alt={`Actualización de ${venue.name}`} fill sizes="(max-width: 768px) 100vw, 512px" loading="eager" className="object-cover" />
        </Link>
      )}

      {update.text && (
        <Link href={`/venue/${venue.id}`} className="block px-4 py-3">
          <p className="text-sm text-gray-800 leading-relaxed">{update.text}</p>
        </Link>
      )}

      <div className="px-4 pb-4 pt-1">
        <button onClick={handleWhatsApp} className="flex items-center gap-2 text-sm text-[#25D366] font-medium">
          <MessageCircle className="w-4 h-4" />
          Contactar por WhatsApp
        </button>
      </div>
    </article>
  );
}

export function MainFeed() {
  const { coordinates, loading: geoLoading } = useGeolocation();
  const [venues, setVenues] = useState<(VenueWithDistance | Venue)[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [radius, setRadius] = useState(9999);

  useEffect(() => {
    setLoading(true);
    setError(null);
    getActiveVenues()
      .then(setVenues)
      .catch((err) => setError(err instanceof Error ? err.message : String(err)))
      .finally(() => setLoading(false));
  }, []);

  useEffect(() => {
    if (geoLoading || !coordinates || radius === 9999) return;
    getVenuesSortedByDistance(coordinates.lat, coordinates.lon, radius)
      .then(setVenues)
      .catch(console.error);
  }, [coordinates, geoLoading, radius]);

  const open = venues.filter((v) => v.status === "open");
  const closed = venues.filter((v) => v.status === "closed");
  const withUpdate = venues.filter((v) => v.daily_update?.text || v.daily_update?.image_url);

  return (
    <div className="flex flex-col">
      <div className="px-4 py-3 bg-white border-b border-gray-100">
        <div className="flex items-center gap-2">
          <Navigation className="w-4 h-4 text-emerald-500 shrink-0" />
          <span className="text-xs text-gray-500 mr-1">Radio:</span>
          <div className="flex gap-1.5 overflow-x-auto">
            {RADIUS_OPTIONS.map((opt) => (
              <button key={opt.value} onClick={() => setRadius(opt.value)}
                className={`shrink-0 px-3 py-1 rounded-full text-xs font-medium transition-colors ${radius === opt.value ? "bg-emerald-500 text-white" : "bg-gray-100 text-gray-600 hover:bg-gray-200"}`}>
                {opt.label}
              </button>
            ))}
          </div>
        </div>
        {!geoLoading && !coordinates && (
          <div className="flex items-center gap-1.5 mt-2 text-xs text-amber-600">
            <MapPin className="w-3 h-3" />
            <span>Ubicación no disponible · mostrando todos los negocios</span>
          </div>
        )}
      </div>

      {loading ? (
        <div className="flex items-center justify-center py-24">
          <Loader2 className="w-8 h-8 animate-spin text-gray-300" />
        </div>
      ) : error ? (
        <div className="px-4 py-8 text-center">
          <p className="text-sm font-medium text-red-500 mb-2">Error al cargar negocios</p>
          <p className="text-xs text-gray-400 break-all">{error}</p>
        </div>
      ) : venues.length === 0 ? (
        <div className="flex flex-col items-center justify-center py-24 gap-2 px-8 text-center">
          <MapPin className="w-10 h-10 text-gray-200" />
          <p className="text-sm font-medium text-gray-500">Sin negocios en este radio</p>
          <p className="text-xs text-gray-400">Prueba aumentando el radio de búsqueda</p>
        </div>
      ) : (
        <>
          <div className="px-4 pt-5 pb-4">
            {open.length > 0 && (
              <section className="mb-5">
                <h2 className="text-sm font-bold text-emerald-600 mb-3">Abiertos · {open.length}</h2>
                <div className="grid grid-cols-3 gap-2.5">
                  {open.map((v) => <GridCard key={v.id} venue={v} />)}
                </div>
              </section>
            )}
            {closed.length > 0 && (
              <section>
                <h2 className="text-sm font-bold text-gray-400 mb-3">Cerrados · {closed.length}</h2>
                <div className="grid grid-cols-3 gap-2.5">
                  {closed.map((v) => <GridCard key={v.id} venue={v} />)}
                </div>
              </section>
            )}
          </div>

          {withUpdate.length > 0 && (
            <div>
              <div className="px-4 py-3 border-t border-b border-gray-100 bg-gray-50">
                <h2 className="text-sm font-bold text-gray-700">Actualizaciones del día</h2>
              </div>
              {withUpdate.map((v) => <FeedCard key={v.id} venue={v} />)}
            </div>
          )}
        </>
      )}
    </div>
  );
}
