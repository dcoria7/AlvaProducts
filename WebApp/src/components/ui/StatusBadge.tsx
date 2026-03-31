import { VenueStatus } from "@/types";

interface StatusBadgeProps {
  status: VenueStatus;
  updatedAt?: { seconds: number } | null;
}

export function StatusBadge({ status, updatedAt }: StatusBadgeProps) {
  const isOpen = status === "open";

  const timeAgo = updatedAt
    ? (() => {
        const diffMin = Math.floor((Date.now() / 1000 - updatedAt.seconds) / 60);
        if (diffMin < 60) return `hace ${diffMin} min`;
        const diffHr = Math.floor(diffMin / 60);
        if (diffHr < 24) return `hace ${diffHr} h`;
        return `hace ${Math.floor(diffHr / 24)} d`;
      })()
    : null;

  return (
    <div className="flex items-center gap-2">
      <span
        className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold ${
          isOpen
            ? "bg-emerald-100 text-emerald-700"
            : "bg-gray-100 text-gray-500"
        }`}
      >
        <span
          className={`w-1.5 h-1.5 rounded-full ${
            isOpen ? "bg-emerald-500 animate-pulse" : "bg-gray-400"
          }`}
        />
        {isOpen ? "Abierto" : "Cerrado"}
      </span>
      {timeAgo && (
        <span className="text-xs text-gray-400">{timeAgo}</span>
      )}
    </div>
  );
}
