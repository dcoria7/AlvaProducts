"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { Venue, MenuItem, Service } from "@/types";
import { getVenueById, getMenuItems, getServices, incrementVenueViews, incrementWhatsappTaps } from "@/services/venues";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { ArrowLeft, MapPin, MessageCircle, Loader2, UtensilsCrossed, Wrench } from "lucide-react";

interface VenueDetailProps {
  venueId: string;
}

function WhatsAppButton({ phone, venueId }: { phone: string; venueId: string }) {
  const cleaned = phone.replace(/\D/g, "");
  async function handleClick() {
    await incrementWhatsappTaps(venueId);
    window.open(`https://wa.me/${cleaned}`, "_blank");
  }
  return (
    <button onClick={handleClick} className="flex items-center justify-center gap-2 w-full py-3.5 bg-[#25D366] text-white font-semibold rounded-2xl hover:bg-[#1ebe5d] transition-colors">
      <MessageCircle className="w-5 h-5" />
      Contactar por WhatsApp
    </button>
  );
}

function MenuSection({ items }: { items: MenuItem[] }) {
  const categories = [...new Set(items.map((i) => i.category))];
  return (
    <section>
      <h2 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
        <UtensilsCrossed className="w-4 h-4 text-gray-400" /> Menú
      </h2>
      <div className="flex flex-col gap-4">
        {categories.map((cat) => (
          <div key={cat}>
            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2">{cat}</p>
            <div className="flex flex-col gap-2">
              {items.filter((i) => i.category === cat).map((item) => (
                <div key={item.id} className="flex items-center justify-between gap-3 p-3 bg-white rounded-xl border border-gray-100">
                  <div className="flex-1 min-w-0">
                    <p className="font-medium text-gray-900 text-sm">{item.name}</p>
                    {item.description && <p className="text-xs text-gray-500 mt-0.5 line-clamp-2">{item.description}</p>}
                  </div>
                  {item.price && <span className="shrink-0 text-sm font-semibold text-gray-900">${Number(item.price).toLocaleString("es-MX")}</span>}
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

function ServicesSection({ services }: { services: Service[] }) {
  return (
    <section>
      <h2 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
        <Wrench className="w-4 h-4 text-gray-400" /> Servicios
      </h2>
      <div className="flex flex-col gap-2">
        {services.map((s) => (
          <div key={s.id} className="flex items-center justify-between gap-3 p-3 bg-white rounded-xl border border-gray-100">
            <div className="flex-1 min-w-0">
              <p className="font-medium text-gray-900 text-sm">{s.name}</p>
              {s.description && <p className="text-xs text-gray-500 mt-0.5">{s.description}</p>}
              {s.duration && <p className="text-xs text-gray-400 mt-0.5">{s.duration} min</p>}
            </div>
            {s.price && <span className="shrink-0 text-sm font-semibold text-gray-900">${Number(s.price).toLocaleString("es-MX")}</span>}
          </div>
        ))}
      </div>
    </section>
  );
}

export function VenueDetail({ venueId }: VenueDetailProps) {
  const [venue, setVenue] = useState<Venue | null>(null);
  const [menuItems, setMenuItems] = useState<MenuItem[]>([]);
  const [services, setServices] = useState<Service[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      const v = await getVenueById(venueId);
      if (!v) { setLoading(false); return; }
      setVenue(v);
      incrementVenueViews(venueId);
      const [menu, svcs] = await Promise.all([
        v.type !== "service" ? getMenuItems(venueId) : Promise.resolve([]),
        v.type !== "food" ? getServices(venueId) : Promise.resolve([]),
      ]);
      setMenuItems(menu);
      setServices(svcs);
      setLoading(false);
    }
    load();
  }, [venueId]);

  if (loading) return <div className="flex items-center justify-center min-h-screen"><Loader2 className="w-8 h-8 animate-spin text-gray-300" /></div>;

  if (!venue) return (
    <div className="flex flex-col items-center justify-center min-h-screen gap-4 px-4 text-center">
      <p className="text-gray-500">Este negocio no existe o no está disponible.</p>
      <Link href="/" className="text-sm text-emerald-600 font-medium">← Volver</Link>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="relative">
        {venue.media.cover_url ? (
          <div className="relative w-full h-52">
            <Image src={venue.media.cover_url} alt={venue.name} fill sizes="(max-width: 768px) 100vw, 512px" priority className="object-cover" />
            <div className="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent" />
          </div>
        ) : (
          <div className="w-full h-28 bg-gradient-to-br from-emerald-400 to-emerald-600" />
        )}
        <Link href="/" className="absolute top-4 left-4 w-9 h-9 bg-white/90 backdrop-blur-sm rounded-full flex items-center justify-center shadow-sm hover:bg-white transition-colors">
          <ArrowLeft className="w-4 h-4 text-gray-700" />
        </Link>
      </div>

      <div className="max-w-lg mx-auto px-4">
        <div className="flex items-end gap-4 -mt-8 mb-4">
          <div className="relative w-16 h-16 rounded-2xl overflow-hidden bg-white shadow-md border-2 border-white shrink-0">
            {venue.media.logo_url ? (
              <Image src={venue.media.logo_url} alt={venue.name} fill sizes="64px" className="object-cover" />
            ) : (
              <div className="w-full h-full bg-emerald-50 flex items-center justify-center">
                <span className="text-2xl font-bold text-emerald-400">{venue.name[0]}</span>
              </div>
            )}
          </div>
          <div className="pb-1">
            <h1 className="text-xl font-bold text-gray-900 leading-tight">{venue.name}</h1>
            <StatusBadge status={venue.status} updatedAt={venue.status_updated_at} />
          </div>
        </div>

        <div className="flex flex-col gap-5 pb-24">
          {venue.description && <p className="text-sm text-gray-600 leading-relaxed">{venue.description}</p>}

          {venue.tags.length > 0 && (
            <div className="flex flex-wrap gap-2">
              {venue.tags.map((tag) => (
                <span key={tag} className="px-2.5 py-1 bg-gray-100 text-gray-600 text-xs rounded-full">{tag}</span>
              ))}
            </div>
          )}

          {venue.daily_update?.text && (
            <div className="p-3 bg-emerald-50 border border-emerald-100 rounded-2xl">
              <p className="text-xs font-semibold text-emerald-700 mb-1">Menú del día</p>
              <p className="text-sm text-emerald-800">{venue.daily_update.text}</p>
              {venue.daily_update.image_url && (
                <div className="relative w-full h-48 mt-3 rounded-xl overflow-hidden">
                  <Image src={venue.daily_update.image_url} alt="Menú del día" fill sizes="(max-width: 768px) 100vw, 512px" className="object-cover" />
                </div>
              )}
            </div>
          )}

          <div className="flex items-start gap-2 text-sm text-gray-600">
            <MapPin className="w-4 h-4 shrink-0 mt-0.5 text-gray-400" />
            <div>
              {venue.location.address ? (
                <a href={`https://maps.google.com/?q=${venue.location.lat},${venue.location.lng}`} target="_blank" rel="noopener noreferrer" className="text-emerald-600 underline underline-offset-2">
                  {venue.location.address}
                </a>
              ) : (
                <span>{venue.location.reference}</span>
              )}
              {venue.location.is_ambulatory && <span className="ml-2 text-xs text-amber-600 font-medium">· Ambulante</span>}
            </div>
          </div>

          {menuItems.length > 0 && <MenuSection items={menuItems} />}
          {services.length > 0 && <ServicesSection services={services} />}
        </div>
      </div>

      <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-gray-100 px-4 py-3">
        <div className="max-w-lg mx-auto">
          <WhatsAppButton phone={venue.contact.phone} venueId={venue.id} />
        </div>
      </div>
    </div>
  );
}
