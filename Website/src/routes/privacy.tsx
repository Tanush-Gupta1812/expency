import { createFileRoute, Link } from "@tanstack/react-router";
import { SiteNav } from "@/components/site/nav";
import { SiteFooter } from "@/components/site/footer";
import { CurrencyProvider } from "@/components/site/currency-context";
import { PrivacyContent } from "@/components/site/privacy-content";
import { PlayStoreBadge } from "@/components/site/play-store-badge";

export const Route = createFileRoute("/privacy")({
  head: () => ({
    meta: [
      { title: "Privacy Policy — Expency (Google Play Ready)" },
      {
        name: "description",
        content:
          "Expency stores everything on-device: no accounts, no servers, no telemetry. Read the full Google Play Store compliant privacy policy.",
      },
      { property: "og:title", content: "Privacy Policy — Expency" },
      {
        property: "og:description",
        content: "No cloud, no tracking. Google Play Store ready privacy policy for Expency.",
      },
    ],
  }),
  component: PrivacyPage,
});

function PrivacyPage() {
  return (
    <CurrencyProvider>
      <div className="min-h-screen bg-background dot-grid">
        <SiteNav />
        <main className="mx-auto max-w-3xl px-5 pb-20 pt-32">
          <p className="hud-label">Document / Legal</p>
          <h1 className="mt-3 font-display text-4xl font-bold">
            Privacy <span className="neon-text">Policy</span>
          </h1>
          <div className="mt-10 glass-card p-6 sm:p-9">
            <PrivacyContent />
          </div>
          <div className="mt-8 flex flex-wrap items-center gap-4">
            <PlayStoreBadge />
            <Link
              to="/"
              className="inline-block font-mono text-xs uppercase tracking-widest text-primary"
            >
              ← Back to home
            </Link>
          </div>
        </main>
        <SiteFooter />
      </div>
    </CurrencyProvider>
  );
}
