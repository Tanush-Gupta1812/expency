import { createFileRoute, Link } from "@tanstack/react-router";
import { SiteNav } from "@/components/site/nav";
import { SiteFooter } from "@/components/site/footer";
import { CurrencyProvider } from "@/components/site/currency-context";
import { TERMS_SECTIONS } from "@/components/site/privacy-content";

export const Route = createFileRoute("/terms")({
  head: () => ({
    meta: [
      { title: "Terms of Service & System Info — Expency" },
      {
        name: "description",
        content:
          "Expency is a personal finance utility, not a bank or licensed advisor. Read the terms of service and device requirements.",
      },
      { property: "og:title", content: "Terms of Service — Expency" },
      {
        property: "og:description",
        content: "Terms governing use of the Expency on-device expense tracker.",
      },
    ],
  }),
  component: TermsPage,
});

function TermsPage() {
  return (
    <CurrencyProvider>
      <div className="min-h-screen bg-background dot-grid">
        <SiteNav />
        <main className="mx-auto max-w-3xl px-5 pb-20 pt-32">
          <p className="hud-label">Document / Legal</p>
          <h1 className="mt-3 font-display text-4xl font-bold">
            Terms of <span className="neon-text">Service</span>
          </h1>
          <div className="mt-10 space-y-7 glass-card p-6 sm:p-9">
            <p className="hud-label">Last Updated: August 2026</p>
            {TERMS_SECTIONS.map((s) => (
              <section key={s.title} className="space-y-2">
                <h2 className="font-mono text-sm font-semibold tracking-wider text-primary">
                  {s.title}
                </h2>
                {s.body.map((p) => (
                  <p key={p} className="text-sm leading-relaxed text-muted-foreground">
                    {p}
                  </p>
                ))}
              </section>
            ))}
          </div>
          <Link
            to="/"
            className="mt-8 inline-block font-mono text-xs uppercase tracking-widest text-primary"
          >
            ← Back to home
          </Link>
        </main>
        <SiteFooter />
      </div>
    </CurrencyProvider>
  );
}
