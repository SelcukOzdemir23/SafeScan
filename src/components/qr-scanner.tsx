'use client';

import { QrCode } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { useToast } from '@/hooks/use-toast';

interface QrScannerProps {
  onUrlScanned: (url: string) => void;
}

export function QrScanner({ onUrlScanned }: QrScannerProps) {
  const { toast } = useToast();

  // Placeholder function to simulate scanning
  const simulateScan = () => {
    // In a real Flutter app, this would use the camera and a QR scanning library.
    // Here, we simulate scanning a few different URLs for testing.
    const urls = [
      'https://www.google.com',
      'https://example-malicious-site.com/phishing',
      'http://potentially-unsafe-download.net/file.exe',
      'https://shortened-url.xyz/abc',
      'invalid-data',
      'ftp://test.com', // Test non-http/https protocol
      'https://picsum.photos/200',
    ];
    const randomUrl = urls[Math.floor(Math.random() * urls.length)];

    toast({
      title: 'Simulated Scan',
      description: `Scanned: ${randomUrl}`,
    });
    onUrlScanned(randomUrl);
  };

  return (
    <Card className="w-full max-w-md mx-auto shadow-lg">
      <CardHeader>
        <CardTitle className="text-center text-xl">Scan QR Code</CardTitle>
      </CardHeader>
      <CardContent className="flex flex-col items-center gap-6">
        <div className="bg-secondary w-64 h-64 rounded-lg flex items-center justify-center border border-dashed border-muted-foreground">
          {/* Placeholder for camera feed */}
          <QrCode className="w-24 h-24 text-muted-foreground" />
        </div>
        <p className="text-center text-muted-foreground text-sm">
          Point your camera at a QR code or click below to simulate a scan.
        </p>
        <Button onClick={simulateScan} className="w-full" variant="secondary">
          <QrCode className="mr-2 h-4 w-4" /> Simulate Scan
        </Button>
      </CardContent>
    </Card>
  );
}
