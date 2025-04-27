import type { SafetyCheckResult } from '@/services/url-safety-checker';
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card';
import { AlertCircle, CheckCircle2, ShieldAlert, ShieldQuestion, ExternalLink } from 'lucide-react';
import { cn } from '@/lib/utils';
import Link from 'next/link';
import { Badge } from "@/components/ui/badge";

interface SafetyResultProps {
  result: SafetyCheckResult & { originalUrl: string };
}

// Define styles based on status - uses custom utility classes from globals.css
const statusStyles: Record<SafetyCheckResult['safetyStatus'], { icon: React.ElementType, colorClass: string, badgeVariant: "default" | "secondary" | "destructive" | "outline" | null | undefined, title: string }> = {
  'Safe': { icon: CheckCircle2, colorClass: 'text-success', badgeVariant: 'default', title: 'URL is Safe' },
  'Unsafe': { icon: AlertCircle, colorClass: 'text-error', badgeVariant: 'destructive', title: 'URL is Unsafe' },
  'Warning': { icon: ShieldAlert, colorClass: 'text-warning', badgeVariant: 'secondary', title: 'Warning Issued' }, // Using secondary badge for warning
  'Unknown': { icon: ShieldQuestion, colorClass: 'text-unknown', badgeVariant: 'outline', title: 'Safety Status Unknown' },
};

export function SafetyResult({ result }: SafetyResultProps) {
  const { safetyStatus, message, originalUrl } = result;
  const { icon: Icon, colorClass, badgeVariant, title } = statusStyles[safetyStatus] || statusStyles['Unknown'];

  return (
    <Card className="w-full max-w-md mx-auto shadow-lg border-t-4" style={{ borderTopColor: `hsl(var(--${badgeVariant === 'destructive' ? 'destructive' : badgeVariant === 'default' ? 'primary' : badgeVariant === 'secondary' ? 'accent' : 'border'}))`}}>
      <CardHeader className="text-center pb-4">
         <div className="flex justify-center mb-3">
           <Icon className={cn("w-12 h-12", colorClass)} />
         </div>
        <CardTitle className={cn("text-2xl font-bold", colorClass)}>
          {title}
        </CardTitle>
         <Badge variant={badgeVariant} className="mx-auto mt-2">{safetyStatus}</Badge>
      </CardHeader>
      <CardContent className="text-center space-y-4">
        {message && (
          <CardDescription className="text-base">{message}</CardDescription>
        )}
        <div className="bg-muted p-3 rounded-md text-left break-all">
          <p className="text-sm font-medium text-foreground mb-1">Scanned URL:</p>
          <Link
            href={originalUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="text-sm text-accent hover:underline inline-flex items-center gap-1"
            title="Open link in new tab (Use caution!)"
            aria-label={`Open scanned URL ${originalUrl} in a new tab (Use caution!)`}
          >
            {originalUrl} <ExternalLink className="w-3 h-3 inline-block ml-1" />
          </Link>
        </div>
         <p className="text-xs text-muted-foreground pt-2">
            Always verify links before clicking. Safety status provided by third-party service.
         </p>
      </CardContent>
    </Card>
  );
}
