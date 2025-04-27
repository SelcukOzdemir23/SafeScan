import { ShieldCheck } from 'lucide-react';
import Link from 'next/link';

export function Header() {
  return (
    <header className="bg-card border-b sticky top-0 z-10 shadow-sm">
      <div className="container mx-auto px-4 h-16 flex items-center">
        <Link href="/" className="flex items-center gap-2 text-xl font-semibold text-primary">
          <ShieldCheck className="h-6 w-6 text-accent" />
          <span>SafeScan</span>
        </Link>
        {/* Add navigation items here if needed */}
      </div>
    </header>
  );
}
