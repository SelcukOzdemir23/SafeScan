'use client';

import { useState, useEffect } from 'react';
import { useFormState, useFormStatus } from 'react-dom';
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

export default function Home() {
  const [urlToCheck, setUrlToCheck] = useState('');
  const [initialState, setInitialState] = useState<{ loading: boolean } | null>(null);
  const [state, formAction] = useFormState(checkUrlAction, initialState);
  const { toast } = useToast();

  // Handle URL scanned from the QR component
  const handleUrlScanned = (scannedUrl: string) => {
    setUrlToCheck(scannedUrl);
    // Automatically submit the form when a URL is scanned
    // Use a temporary form data object
    const formData = new FormData();
    formData.append('url', scannedUrl);
    setInitialState({ loading: true }); // Set loading state before dispatch
    formAction(formData);
  };

  // Update input field when state changes (e.g., after scan)
  useEffect(() => {
    if (state?.result?.originalUrl) {
      setUrlToCheck(state.result.originalUrl);
    } else if (!state?.loading && urlToCheck) {
       // If not loading and there was a URL but no result, clear it? Or keep it?
       // Let's keep it for now, user might want to retry manually.
    }
  }, [state, urlToCheck]);


  // Show toast on error
   useEffect(() => {
    if (state?.error) {
      toast({
        variant: "destructive",
        title: "Error",
        description: state.error,
      });
       setInitialState(null); // Reset initial state after showing error
    }
  }, [state?.error, toast]);


  // Reset form / show scanner again
  const handleReset = () => {
    setUrlToCheck('');
    setInitialState(null); // Reset the form state
     // Clear the result/error display by essentially resetting the state passed to useFormState
     // This requires a bit of a trick, maybe re-keying the component or explicitly setting state to null
     // For now, setting initial state to null is the simplest approach with useFormState.
     // If using a local state management, it would be cleaner.
  };

  return (
    <div className="flex flex-col items-center gap-8 w-full">
      {/* Show Scanner if no result/error is present */}
      {!state?.result && !state?.error && !state?.loading && (
        <>
         <p className="text-center text-muted-foreground max-w-xl">
            Scan a QR code to automatically check its embedded link, or enter a URL manually below to check its safety.
          </p>
          <QrScanner onUrlScanned={handleUrlScanned} />
        </>
      )}

       {/* Loading Indicator */}
      {state?.loading && (
        <div className="flex flex-col items-center gap-4 text-center p-8">
          <Loader2 className="h-12 w-12 animate-spin text-accent" />
          <p className="text-lg font-medium text-muted-foreground">Checking URL safety...</p>
          {urlToCheck && <p className="text-sm text-muted-foreground break-all">Checking: {urlToCheck}</p>}
        </div>
      )}

      {/* Show Result if available */}
      {state?.result && !state?.loading && (
        <>
          <SafetyResult result={state.result} />
          <Button onClick={handleReset} variant="outline">Scan Another QR Code</Button>
        </>
      )}

       {/* Show Error if present and not loading */}
       {state?.error && !state?.loading && (
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
       {!state?.result && !state?.loading && (
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
              />
            </div>
            <SubmitButton />
          </form>
       )}
    </div>
  );
}
