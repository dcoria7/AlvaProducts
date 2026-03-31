import { Header } from "@/components/layout/Header";
import { VenueFeed } from "@/components/venue/VenueFeed";

export default function Home() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Header />
      <main className="max-w-lg mx-auto px-4 py-6">
        <VenueFeed />
      </main>
    </div>
  );
}
