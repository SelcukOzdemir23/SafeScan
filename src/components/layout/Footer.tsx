export function Footer() {
  return (
    <footer className="bg-muted py-4 mt-auto">
      <div className="container mx-auto px-4 text-center text-muted-foreground text-sm">
        © {new Date().getFullYear()} SafeScan. All rights reserved.
        <p className="mt-1 text-xs">
          Disclaimer: Safety checks are based on third-party data and may not be 100% accurate. Always exercise caution when clicking links.
        </p>
      </div>
    </footer>
  );
}
