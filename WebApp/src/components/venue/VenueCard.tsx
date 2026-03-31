import Link from "next/link";
import Image from "next/image";
import { VenueWithDistance, Venue } from "@/types";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { DistanceBadge } from "@/components/ui/DistanceBadge";
import { UtensilsCrossed, Wrench, Layers } from "lucide-react";

const TYPE_ICON = {
  food: UtensilsCrossed,
  service: Wrench,
  both: Layers,
};

const TYPE_LABEL = {
  food: "Comida",
  service: "Servicio",
  both: "Comida y servicio",
};

interface VenueCardProps {
  venue: VenueWithDistance | Venue;
}

export function VenueCard({ venue }: VenueCardProps) {
  const distanceKm = "distanceKm" in venue ? venue.distanceKm : null;
  const Icon = TYPE_ICON[venue.type];

  return (
    <Link
      href={`/venue/${venue.id}`}
      className="flex gap-4 p-4 bg-white rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow active:scale-[0.99]"
    >
      {/* Logo */}
      <div className="relative w-16 h-16 shrink-0 rounded-xl overflow-hidden bg-gray-100">
        {venue.media.logoUrl ? (
          <Image
            src={venue.media.logoUrl}
            alt={venue.name}
            fill
            className="object-cover"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center">
            <Icon className="w-7 h-7 text-gray-300" />
          </div>
        )}
      </div>

      {/* Info */}
      <div className="flex-1 min-w-0">
        <div className="flex items-start justify-between gap-2">
          <h3 className="font-semibold text-gray-900 truncate">{venue.name}</h3>
          <StatusBadge
            status={venue.status}
            updatedAt={venue.statusUpdatedAt as unknown as { seconds: number }}
          />
        </div>

        <p className="text-sm text-gray-500 mt-0.5 line-clamp-2">
          {venue.description}
        </p>

        <div className="flex items-center gap-3 mt-2">
          <span className="inline-flex items-center gap-1 text-xs text-gray-400">
            <Icon className="w-3 h-3" />
            {TYPE_LABEL[venue.type]}
          </span>

          {distanceKm !== null && (
            <DistanceBadge
              distanceKm={distanceKm}
              reference={venue.location.reference}
            />
          )}

          {venue.location.isAmbulatory && (
            <span className="text-xs text-amber-600 font-medium">Ambulante</span>
          )}
        </div>

        {/* Menú del día */}
        {venue.dailyUpdate?.text && (
          <p className="mt-2 text-xs text-emerald-700 bg-emerald-50 rounded-lg px-2 py-1 line-clamp-1">
            📋 {venue.dailyUpdate.text}
          </p>
        )}
      </div>
    </Link>
  );
}
