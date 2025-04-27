/**
 * Represents the safety status of a URL.
 */
export type SafetyStatus = 'Safe' | 'Unsafe' | 'Warning' | 'Unknown';

/**
 * Represents the result of a URL safety check.
 */
export interface SafetyCheckResult {
  /**
   * The safety status of the URL.
   */
  safetyStatus: SafetyStatus;
  /**
   * A message providing more details about the safety status.
   */
  message?: string;
}

/**
 * Asynchronously checks the safety of a given URL.
 * This is a MOCKED implementation for frontend demonstration.
 * In a real application, this logic would be within a backend service
 * (like a Firebase Function) calling a real safety API.
 *
 * @param url The URL to check.
 * @returns A promise that resolves to a SafetyCheckResult object.
 */
export async function checkUrlSafety(url: string): Promise<SafetyCheckResult> {
  console.log(`[Mock Service] Checking URL: ${url}`);

  // Simulate network delay
  // await new Promise(resolve => setTimeout(resolve, 1000)); // Removed, delay handled in action

  // Validate URL format crudely for the mock
  try {
    new URL(url); // Basic validation
  } catch (_) {
    console.log('[Mock Service] Invalid URL format detected');
    // throw new Error("Invalid URL format provided to checker."); // Let zod handle validation primarily
     return { safetyStatus: 'Unknown', message: 'Invalid URL format provided.' };
  }


  // Mock different responses based on the URL content
  if (url.includes('google.com') || url.includes('picsum.photos') || url.includes('safe-site.com')) {
    console.log('[Mock Service] URL classified as Safe');
    return {
      safetyStatus: 'Safe',
      message: 'This URL is known to be safe based on our checks.',
    };
  }

  if (url.includes('malicious-site.com') || url.includes('phishing')) {
    console.log('[Mock Service] URL classified as Unsafe');
    return {
      safetyStatus: 'Unsafe',
      message: 'Warning! This URL is flagged as potentially malicious or involved in phishing activities.',
    };
  }

  if (url.includes('potentially-unsafe') || url.includes('download.net')) {
     console.log('[Mock Service] URL classified as Warning');
    return {
      safetyStatus: 'Warning',
      message: 'Caution! This URL may lead to unwanted software or suspicious content. Proceed with care.',
    };
  }

  if (url.includes('shortened-url')) {
     console.log('[Mock Service] URL classified as Unknown (shortened)');
    return {
        safetyStatus: 'Unknown',
        message: 'This is a shortened URL. We cannot determine the safety of the final destination without following it.',
      };
  }

   // Default to Unknown for other valid URLs
   console.log('[Mock Service] URL classification is Unknown');
   return {
     safetyStatus: 'Unknown',
     message: 'The safety status of this URL could not be determined.',
   };
}
