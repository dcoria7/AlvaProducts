"use client";

import { VenueType, VenueStatus } from "@/types";

type FilterType = "all" | VenueType;
type FilterStatus = "all" | VenueStatus;

interface FilterTabsProps {
  activeType: FilterType;
  activeStatus: FilterStatus;
  onTypeChange: (type: FilterType) => void;
  onStatusChange: (status: FilterStatus) => void;
}

const TYPE_OPTIONS: { value: FilterType; label: string }[] = [
  { value: "all", label: "Todos" },
  { value: "food", label: "Comida" },
  { value: "service", label: "Servicios" },
];

const STATUS_OPTIONS: { value: FilterStatus; label: string }[] = [
  { value: "all", label: "Todos" },
  { value: "open", label: "Abiertos" },
  { value: "closed", label: "Cerrados" },
];

export function FilterTabs({
  activeType,
  activeStatus,
  onTypeChange,
  onStatusChange,
}: FilterTabsProps) {
  return (
    <div className="flex flex-col gap-2">
      <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
        {TYPE_OPTIONS.map((opt) => (
          <button
            key={opt.value}
            onClick={() => onTypeChange(opt.value)}
            className={`shrink-0 px-3 py-1.5 rounded-full text-sm font-medium transition-colors ${
              activeType === opt.value
                ? "bg-gray-900 text-white"
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            {opt.label}
          </button>
        ))}
      </div>
      <div className="flex gap-2">
        {STATUS_OPTIONS.map((opt) => (
          <button
            key={opt.value}
            onClick={() => onStatusChange(opt.value)}
            className={`shrink-0 px-3 py-1.5 rounded-full text-sm font-medium transition-colors ${
              activeStatus === opt.value
                ? opt.value === "open"
                  ? "bg-emerald-500 text-white"
                  : opt.value === "closed"
                  ? "bg-gray-500 text-white"
                  : "bg-gray-900 text-white"
                : "bg-gray-100 text-gray-600 hover:bg-gray-200"
            }`}
          >
            {opt.label}
          </button>
        ))}
      </div>
    </div>
  );
}
