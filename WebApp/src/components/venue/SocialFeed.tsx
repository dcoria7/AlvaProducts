"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { Venue } from "@/types";
import { getFeedVenues, getActiveVenues, incrementWhatsappTaps } from "@/services/venues";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { MessageCircle, Loader2, Newspaper } from "lucide-react";

function timeAgo(seconds: number): string {
  const diff = Math.floor(Date.now() / 1000 - seconds);
  if (diff < 60) return "ahora";
  if (diff < 3600) return `hace ${Math.floor(diff / 60)} min`;
  if (diff < 86400) return `hace ${Math.floor(diff / 3600)} h`;
  return `hace ${Math.floor(diff / 86400)} d`;
}

function FeedCard({ venue }: { venue: Venue }) {
  const update = venue.dailyUpdate!;
  const phone = venue.contact.phone.replace(/\D/g, "");

  async function handleWhatsApp() {
    await incrementWhatsappTaps(venue.id);
    window.open(`https://wa.me/${phone}`, "_blank");
  }

  return (
    <article className="bg-white border-b border-gray-100">
      {/* Header de la tarjeta */}
      <Link href={`/venue/${venue.id}`} className="flex items-center gap-3 px-4 py-3">
        <div className="relative w-10 h-10 rounded-full overflow-hidden bg-emerald-50 shrink-0">
          {venue.media.logoUrl ? (
            <Image src={venue.media.logoUrl} alt={venue.name} fill className="object-cover" />
          ) : (
            <div className="w-full h-full flex items-center justify-center">
              <span className="text-base font-bold text-emerald-400">{venue.name[0]}</span>
            </div>
          )}
        </div>
        <div className="flex-1 min-w-0">
          <p className="font-semibold text-gray-900 text-sm truncate">{venue.name}</p>
          <div className="flex items-center gap-2">
            <StatusBadge status={venue.status} updatedAt={venue.statusUpdatedAt as unknown as { seconds: number }} />
            {update.updatedAt && (
              <span className="text-xs text-gray-400">
                {timeAgo((update.updatedAt as unknown as { seconds: number }).seconds)}
              </span>
            )}
          </div>
        </div>
      </Link>

      {/* Imagen del update */}
      {update.imageUrl && (
        <Link href={`/venue/${venue.id}`} className="block relative w-full aspect-square">
          <Image
            src={update.imageUrl}
            alt={`Actualización de ${venue.name}`}
            fill
            className="object-cover"
          />
        </Link>
      )}

      {/* Texto del update */}
      {update.text && (
        <Link href={`/venue/${venue.id}`} className="block px-4 py-3">
          <p className="text-sm text-gray-800 leading-relaxed">{update.text}</p>
        </Link>
      )}

      {/* CTA WhatsApp */}
      <div className="px-4 pb-4 pt-1">
        <button
          onClick={handleWhatsApp}
          className="flex items-center gap-2 text-sm text-[#25D366] font-medium hover:opacity-80 transition-opacity"
        >
          <MessageCircle className="w-4 h-4" />
          Pedir / Contactar
        </button>
      </div>
    </article>
  );
}

function EmptyFeed() {
  return (
    <div className="flex flex-col items-center justify-center py-24 gap-3 text-gray-400 px-8 text-center">
      <Newspaper className="w-12 h-12 text-gray-200" />
      <p className="font-medium text-gray-500">Sin actualizaciones hoy</p>
      <p className="text-sm text-gray-400">
        Los negocios aún no han publicado su menú del día.
        <br />Revisa más tarde o explora los negocios.
      </p>
      <Link
        href="/negocios"
        className="mt-2 px-4 py-2 bg-emerald-500 text-white text-sm font-medium rounded-full hover:bg-emerald-600 transition-colors"
      >
        Ver negocios
      </Link>
    </div>
  );
}

export function SocialFeed() {
  const [feedVenues, setFeedVenues] = useState<Venue[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      try {
        let venues = await getFeedVenues();
        // Si no hay venues con dailyUpdate, muestra todos los activos como fallback
        if (venues.length === 0) {
          venues = await getActiveVenues();
        }
        setFeedVenues(venues);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, []);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-24">
        <Loader2 className="w-8 h-8 animate-spin text-gray-300" />
      </div>
    );
  }

  const withUpdates = feedVenues.filter((v) => v.dailyUpdate?.text || v.dailyUpdate?.imageUrl);
  const withoutUpdates = feedVenues.filter((v) => !v.dailyUpdate?.text && !v.dailyUpdate?.imageUrl);

  if (feedVenues.length === 0) return <EmptyFeed />;

  return (
    <div className="flex flex-col">
      {withUpdates.map((venue) => (
        <FeedCard key={venue.id} venue={venue} />
      ))}

      {/* Negocios sin update del día, mostrados como lista compacta */}
      {withoutUpdates.length > 0 && (
        <div className="px-4 py-4">
          <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3">
            Más negocios abiertos
          </p>
          <div className="flex flex-col gap-2">
            {withoutUpdates.map((venue) => (
              <Link
                key={venue.id}
                href={`/venue/${venue.id}`}
                className="flex items-center gap-3 p-3 bg-white rounded-xl border border-gray-100"
              >
                <div className="relative w-9 h-9 rounded-full overflow-hidden bg-emerald-50 shrink-0">
                  {venue.media.logoUrl ? (
                    <Image src={venue.media.logoUrl} alt={venue.name} fill className="object-cover" />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center">
                      <span className="text-sm font-bold text-emerald-400">{venue.name[0]}</span>
                    </div>
                  )}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="font-medium text-gray-900 text-sm truncate">{venue.name}</p>
                  <p className="text-xs text-gray-400 truncate">{venue.location.reference}</p>
                </div>
                <StatusBadge status={venue.status} />
              </Link>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
