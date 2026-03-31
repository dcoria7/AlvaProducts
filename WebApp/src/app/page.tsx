import { Header } from "@/components/layout/Header";
import { SocialFeed } from "@/components/venue/SocialFeed";

export default function Home() {
  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <Header />
      <main className="max-w-lg mx-auto">
        <SocialFeed />
      </main>
    </div>
  );
}
