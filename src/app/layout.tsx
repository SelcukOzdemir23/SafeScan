import type { Metadata } from 'next';
import { Geist, Geist_Mono } from 'next/font/google';
import './globals.css';
import { cn } from '@/lib/utils';
import { Header } from '@/components/layout/Header';
import { Footer } from '@/components/layout/Footer';
import { Toaster } from '@/components/ui/toaster'; // Ensure Toaster is imported

const geistSans = Geist({
  variable: '--font-geist-sans',
  subsets: ['latin'],
});

const geistMono = Geist_Mono({
  variable: '--font-geist-mono',
  subsets: ['latin'],
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
    <html lang="en" className="h-full">
      <body
        className={cn(
          `${geistSans.variable} ${geistMono.variable} antialiased`,
          'flex flex-col min-h-screen' // Ensure body takes full height and uses flex column
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
