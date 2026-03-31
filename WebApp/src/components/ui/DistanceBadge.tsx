import { MapPin } from "lucide-react";

interface DistanceBadgeProps {
  distanceKm: number;
  reference?: string;
}

export function DistanceBadge({ distanceKm, reference }: DistanceBadgeProps) {
  const label =
    distanceKm < 1
      ? `${Math.round(distanceKm * 1000)} m`
      : `${distanceKm.toFixed(1)} km`;

  return (
    <div className="flex items-center gap-1 text-xs text-gray-500">
      <MapPin className="w-3 h-3 shrink-0" />
      <span>{label}</span>
      {reference && <span className="text-gray-400">· {reference}</span>}
    </div>
  );
}
