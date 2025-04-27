'use server';

import { z } from 'zod';
import { checkUrlSafety, type SafetyCheckResult } from '@/services/url-safety-checker';

const urlSchema = z.string().url({ message: "Invalid URL format." });

// Define the state shape returned by the action
interface CheckUrlState {
  result?: SafetyCheckResult & { originalUrl: string };
  error?: string;
  // loading is no longer needed here, useActionState provides pending state
}

export async function checkUrlAction(
  // The previous state is the first argument
  prevState: CheckUrlState | null,
  formData: FormData,
): Promise<CheckUrlState> {
  const urlInput = formData.get('url') as string | null;

  if (!urlInput) {
    // Return the error state, no loading needed
    return { error: "URL is required." };
  }

  try {
    const validatedUrl = urlSchema.parse(urlInput);

    console.log(`Checking URL: ${validatedUrl}`); // Add logging
    // Simulate API call delay (optional, can be removed if handled by pending state visually)
    // await new Promise(resolve => setTimeout(resolve, 1500));

    // In a real app, this would call the backend service (e.g., Firebase Function)
    // which then calls the external safety API.
    // For this example, we'll use the mocked service directly.
    const safetyResult = await checkUrlSafety(validatedUrl);
    console.log(`Safety Result: ${JSON.stringify(safetyResult)}`); // Add logging

    // Return the success state with the result
    return {
      result: { ...safetyResult, originalUrl: validatedUrl },
    };
  } catch (error) {
    console.error("Error checking URL:", error); // Add logging
    if (error instanceof z.ZodError) {
      // Return the error state with validation message
      return { error: error.errors[0]?.message || "Invalid URL format." };
    }
    // Handle other potential errors (network, API errors from checkUrlSafety)
    // Return the generic error state
    return { error: "An error occurred while checking the URL." };
  }
}
