import { Header } from "@/components/layout/Header";
import { VenueGrid } from "@/components/venue/VenueGrid";

export const dynamic = "force-dynamic";

export default function NegociosPage() {
  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <Header subtitle="Negocios cerca de ti" />
      <main className="max-w-lg mx-auto px-4 py-5">
        <VenueGrid />
      </main>
    </div>
  );
}
