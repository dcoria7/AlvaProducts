import { VenueDetail } from "@/components/venue/VenueDetail";

interface PageProps {
  params: Promise<{ id: string }>;
}

export default async function VenuePage({ params }: PageProps) {
  const { id } = await params;
  return <VenueDetail venueId={id} />;
}
