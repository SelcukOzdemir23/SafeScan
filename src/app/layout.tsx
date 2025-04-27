import type { Metadata } from 'next';
import { Geist, Geist_Mono } from 'next/font/google';
import './globals.css';
import { cn } from '@/lib/utils';
import { Header } from '@/components/layout/Header';
import { Footer } from '@/components/layout/Footer';
import { Toaster } from '@/components/ui/toaster'; // Ensure Toaster is imported

// Define fonts
const geistSans = Geist({
  variable: '--font-geist-sans',
  subsets: ['latin'],
  display: 'swap', // Improve font loading behavior
});

const geistMono = Geist_Mono({
  variable: '--font-geist-mono',
  subsets: ['latin'],
  display: 'swap', // Improve font loading behavior
});

export const metadata: Metadata = {
  title: 'SafeScan - QR Code Link Safety Checker',
  description: 'Scan QR codes and check the safety of embedded links.',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    // Apply font variables directly to the html tag and suppress hydration warnings
    <html lang="en" className={cn(geistSans.variable, geistMono.variable, 'h-full')} suppressHydrationWarning={true}>
      <body
        // Apply utility classes and ensure base styles are set
        className={cn(
          'antialiased', // Keep antialiased for smoother text
          'flex flex-col min-h-screen bg-background text-foreground' // Set base bg/text and layout structure
        )}
      >
        <Header />
        <main className="flex-grow container mx-auto px-4 py-8">
          {children}
        </main>
        <Footer />
        <Toaster /> {/* Add Toaster here */}
      </body>
    </html>
  );
}
