'use client';

import { useState, useEffect, useActionState } from 'react'; // Import useActionState from 'react'
// Remove import from 'react-dom' if it was used for useFormState
import { useFormStatus } from 'react-dom';
import { checkUrlAction } from './actions';
import { QrScanner } from '@/components/qr-scanner';
import { SafetyResult } from '@/components/safety-result';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert';
import { Loader2, AlertTriangle, Send } from 'lucide-react';
import { useToast } from '@/hooks/use-toast';

function SubmitButton() {
  const { pending } = useFormStatus();
  return (
    <Button type="submit" disabled={pending} className="w-full sm:w-auto">
      {pending ? (
        <>
          <Loader2 className="mr-2 h-4 w-4 animate-spin" /> Checking...
        </>
      ) : (
        <>
         <Send className="mr-2 h-4 w-4" /> Check URL Manually
        </>
      )}
    </Button>
  );
}

// Define the initial state type clearly
type CheckUrlInitialState = { loading: boolean; error?: string; result?: any } | null;

export default function Home() {
  const [urlToCheck, setUrlToCheck] = useState('');
  // Define initial state for useActionState
  const initialActionState: CheckUrlInitialState = null;
  const [state, formAction, isPending] = useActionState(checkUrlAction, initialActionState); // Use useActionState
  const { toast } = useToast();

  // Handle URL scanned from the QR component
  const handleUrlScanned = (scannedUrl: string) => {
    setUrlToCheck(scannedUrl);
    // Automatically submit the form when a URL is scanned
    const formData = new FormData();
    formData.append('url', scannedUrl);
    // No need to set loading state manually here, useActionState handles pending state (isPending)
    formAction(formData);
  };

  // Update input field when state changes (e.g., after scan)
  useEffect(() => {
    if (state?.result?.originalUrl) {
      setUrlToCheck(state.result.originalUrl);
    }
  }, [state?.result?.originalUrl]);


  // Show toast on error
   useEffect(() => {
    if (state?.error) {
      toast({
        variant: "destructive",
        title: "Error",
        description: state.error,
      });
       // Consider if resetting state is needed here, useActionState manages state lifecycle
    }
  }, [state?.error, toast]);


  // Reset form / show scanner again
  const handleReset = () => {
    setUrlToCheck('');
     // Resetting useActionState often involves re-triggering an action or re-mounting the component.
     // For simplicity here, we might just clear the visual state, but a cleaner approach
     // might involve managing the view state differently or using a key on the form/component.
     // We'll rely on the conditional rendering logic based on `state` being null/having result/error.
     // To truly reset the ActionState, you might need a more complex pattern or trigger a reset action.
     // For now, we clear the input and let conditional rendering handle the rest.
     window.location.reload(); // Simplest way to reset state for now
  };

  const isLoading = isPending || state?.loading; // Combine pending state from hook and manual state if needed

  return (
    <div className="flex flex-col items-center gap-8 w-full">
      {/* Show Scanner if no result/error is present and not loading */}
      {!state?.result && !state?.error && !isLoading && (
        <>
         <p className="text-center text-muted-foreground max-w-xl">
            Scan a QR code to automatically check its embedded link, or enter a URL manually below to check its safety.
          </p>
          <QrScanner onUrlScanned={handleUrlScanned} />
        </>
      )}

       {/* Loading Indicator */}
      {isLoading && (
        <div className="flex flex-col items-center gap-4 text-center p-8">
          <Loader2 className="h-12 w-12 animate-spin text-accent" />
          <p className="text-lg font-medium text-muted-foreground">Checking URL safety...</p>
          {urlToCheck && <p className="text-sm text-muted-foreground break-all">Checking: {urlToCheck}</p>}
        </div>
      )}

      {/* Show Result if available */}
      {state?.result && !isLoading && (
        <>
          <SafetyResult result={state.result} />
          <Button onClick={handleReset} variant="outline">Scan Another QR Code</Button>
        </>
      )}

       {/* Show Error if present and not loading */}
       {state?.error && !isLoading && (
         <div className="w-full max-w-md flex flex-col items-center gap-4">
            <Alert variant="destructive" className="w-full">
              <AlertTriangle className="h-4 w-4" />
              <AlertTitle>Check Failed</AlertTitle>
              <AlertDescription>{state.error}</AlertDescription>
            </Alert>
           <Button onClick={handleReset} variant="outline">Try Again</Button>
         </div>
       )}


      {/* Manual URL Input Form - Conditionally shown */}
       {!state?.result && !isLoading && (
          <form action={formAction} className="w-full max-w-md space-y-4 border-t pt-8 mt-8">
             <h2 className="text-lg font-semibold text-center mb-4">Or Check URL Manually</h2>
            <div className="space-y-2">
              <Label htmlFor="url-input">Enter URL</Label>
              <Input
                id="url-input"
                name="url"
                type="url"
                placeholder="https://example.com"
                value={urlToCheck}
                onChange={(e) => setUrlToCheck(e.target.value)}
                required
                className="bg-card"
                disabled={isPending} // Disable input while pending
              />
            </div>
            <SubmitButton /> {/* SubmitButton uses useFormStatus which works with useActionState */}
          </form>
       )}
    </div>
  );
}
