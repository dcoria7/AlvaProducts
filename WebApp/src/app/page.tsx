import { Header } from "@/components/layout/Header";
import { MainFeed } from "@/components/venue/MainFeed";
import { DebugFirestore } from "@/components/DebugFirestore";

export default function Home() {
  return (
    <div className="min-h-screen bg-gray-50 pb-6">
      <Header />
      <main className="max-w-lg mx-auto">
        <DebugFirestore />
        <MainFeed />
      </main>
    </div>
  );
}
