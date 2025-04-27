'use server';

import { z } from 'zod';
import { checkUrlSafety, type SafetyCheckResult } from '@/services/url-safety-checker';

const urlSchema = z.string().url({ message: "Invalid URL format." });

interface CheckUrlState {
  result?: SafetyCheckResult & { originalUrl: string };
  error?: string;
  loading: boolean;
}

export async function checkUrlAction(
  prevState: CheckUrlState | null, // Add prevState
  formData: FormData,
): Promise<CheckUrlState> {
  const urlInput = formData.get('url') as string | null;

  if (!urlInput) {
    return { error: "URL is required.", loading: false };
  }

  try {
    const validatedUrl = urlSchema.parse(urlInput);

    console.log(`Checking URL: ${validatedUrl}`); // Add logging
    // Simulate API call delay
    await new Promise(resolve => setTimeout(resolve, 1500));

    // In a real app, this would call the backend service (e.g., Firebase Function)
    // which then calls the external safety API.
    // For this example, we'll use the mocked service directly.
    const safetyResult = await checkUrlSafety(validatedUrl);
    console.log(`Safety Result: ${JSON.stringify(safetyResult)}`); // Add logging

    return {
      result: { ...safetyResult, originalUrl: validatedUrl },
      loading: false,
    };
  } catch (error) {
    console.error("Error checking URL:", error); // Add logging
    if (error instanceof z.ZodError) {
      return { error: error.errors[0]?.message || "Invalid URL format.", loading: false };
    }
    // Handle other potential errors (network, API errors from checkUrlSafety)
    return { error: "An error occurred while checking the URL.", loading: false };
  }
}