import { createFileRoute, Link } from "@tanstack/react-router";
import { useState } from "react";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { SiteNav } from "@/components/site/nav";
import { SiteFooter } from "@/components/site/footer";
import { CursorGlow } from "@/components/site/cursor-glow";
import { CurrencyProvider } from "@/components/site/currency-context";
import { PhoneMockup } from "@/components/site/phone-mockup";
import { BudgetHud } from "@/components/site/budget-hud";
import { CurrencyCalculator } from "@/components/site/currency-calculator";
import { PlayStoreBadge } from "@/components/site/play-store-badge";
import { PrivacyContent, TERMS_SECTIONS } from "@/components/site/privacy-content";

export const Route = createFileRoute("/")({
  head: () => ({
    meta: [
      { title: "Expency — Zero-Cloud, On-Device Expense Tracker" },
      {
        name: "description",
        content:
          "Take absolute control of your money. Expency is a fully on-device expense manager with local OCR receipt scanning, adaptive budget alerts and zero data leakage.",
      },
      { property: "og:title", content: "Expency — Zero Cloud. Zero Tracking." },
      {
        property: "og:description",
        content:
          "A high-performance, fully on-device expense manager with smart receipt scanning and dynamic budget alerts.",
      },
    ],
  }),
  component: Index,
});

const PILLARS = [
  {
    tag: "01",
    title: "100% On-Device Local Storage",
    body: "No servers, no signups, no database leaks. Your financial data never leaves your phone — there is literally nothing to breach.",
    accent: "var(--primary)",
    icon: "🛡️",
  },
  {
    tag: "02",
    title: "On-Device OCR Screenshot Parsing",
    body: "Snap or screenshot any UPI / bank transaction (GPay, PhonePe, Paytm) and ML Kit instantly extracts the recipient and amount — locally.",
    accent: "var(--income)",
    icon: "🧾",
  },
  {
    tag: "03",
    title: "Adaptive Budget HUD",
    body: "Interface colors shift from Neon Cyan → Warning Yellow → Critical Orange → Red as you approach your spending limits.",
    accent: "var(--expense)",
    icon: "📈",
  },
];

const FAQS = [
  {
    q: "Does Expency link to my bank account?",
    a: "No. Expency deliberately avoids Open Banking APIs and third-party aggregator credentials. Nothing to authorize, nothing to revoke, nothing to leak — you add transactions manually or via local screenshot parsing.",
  },
  {
    q: "Can I backup my data?",
    a: "Yes. Export a full CSV of your ledger at any time, and rely on your device's own encrypted local backups. Backups are yours to store wherever you choose.",
  },
  {
    q: "Is the screenshot parser sending my images online?",
    a: "No. Text recognition runs entirely on your processor using Google ML Kit's on-device models. No image, no OCR text, and no metadata is ever uploaded.",
  },
  {
    q: "Do I need an account to use Expency?",
    a: "There are no accounts at all. Install the app and start tracking — there is no email, no password and no user record anywhere.",
  },
  {
    q: "How does biometric protection work?",
    a: "Destructive actions like purging data are gated behind your OS biometric prompt. Expency never sees or stores your fingerprint or face template.",
  },
];

function Index() {
  const [privacy, setPrivacy] = useState(false);

  return (
    <CurrencyProvider>
      <div className="relative min-h-screen overflow-x-hidden bg-background dot-grid">
        <CursorGlow />
        <SiteNav />

        <main className="relative z-10">
          {/* HERO */}
          <section className="mx-auto max-w-7xl px-5 pb-20 pt-32 lg:pt-40">
            <div className="grid items-center gap-14 lg:grid-cols-2">
              <div>
                <span className="inline-flex items-center gap-2 rounded-full border border-primary/40 bg-primary/5 px-3 py-1.5 font-mono text-[11px] uppercase tracking-widest text-primary">
                  <span className="size-1.5 rounded-full bg-primary pulse-dot" />
                  Finance_Core · v2.6 · Offline
                </span>
                <h1 className="mt-6 font-display text-4xl font-bold leading-[1.05] sm:text-5xl lg:text-6xl">
                  Take Absolute Control of Your Money.
                  <span className="mt-2 block neon-text">Zero Cloud. Zero Tracking.</span>
                </h1>
                <p className="mt-6 max-w-xl text-base leading-relaxed text-muted-foreground">
                  A high-performance, fully on-device expense manager with smart receipt
                  screenshot scanning, dynamic budget alerts, and zero data leakage.
                </p>

                <div id="download" className="mt-9 flex flex-wrap items-center gap-4">
                  <PlayStoreBadge />
                  <a
                    href="#features"
                    className="rounded-full border border-border px-6 py-3 font-mono text-xs uppercase tracking-widest text-foreground transition-all hover:border-primary/60 hover:text-primary"
                  >
                    Explore Features
                  </a>
                </div>

                <div className="mt-6 flex flex-wrap gap-3">
                  {["⌦ APK Direct", "⌥ GitHub Release"].map((b) => (
                    <span
                      key={b}
                      className="rounded-lg border border-border bg-white/[0.02] px-4 py-2 font-mono text-[11px] tracking-widest text-muted-foreground"
                    >
                      {b}
                    </span>
                  ))}
                </div>

                <dl className="mt-10 grid max-w-lg grid-cols-3 gap-4 border-t border-border pt-6">
                  {[
                    ["0", "Servers"],
                    ["0", "Trackers"],
                    ["100%", "On-device"],
                  ].map(([v, k]) => (
                    <div key={k}>
                      <dt className="font-mono text-2xl font-bold text-primary">{v}</dt>
                      <dd className="hud-label mt-1">{k}</dd>
                    </div>
                  ))}
                </dl>
              </div>

              <PhoneMockup />
            </div>
          </section>

          {/* ZERO-CLOUD DIFFERENCE */}
          <section id="privacy-architecture" className="mx-auto max-w-7xl px-5 py-20">
            <p className="hud-label">Value Proposition</p>
            <h2 className="mt-3 font-display text-3xl font-bold sm:text-4xl">
              The <span className="neon-text">Zero-Cloud</span> Difference
            </h2>
            <div className="mt-10 grid gap-6 md:grid-cols-3">
              {PILLARS.map((p) => (
                <article key={p.tag} className="glass-card p-7">
                  <div className="flex items-center justify-between">
                    <span className="text-2xl">{p.icon}</span>
                    <span className="font-mono text-[11px] tracking-widest text-muted-foreground">
                      {p.tag}
                    </span>
                  </div>
                  <h3
                    className="mt-5 text-lg font-semibold"
                    style={{ color: p.accent, textShadow: `0 0 22px ${p.accent}55` }}
                  >
                    {p.title}
                  </h3>
                  <p className="mt-3 text-sm leading-relaxed text-muted-foreground">{p.body}</p>
                </article>
              ))}
            </div>
          </section>

          {/* FEATURE SHOWCASE */}
          <section id="features" className="mx-auto max-w-7xl px-5 py-20">
            <p className="hud-label">Interactive Showcase</p>
            <h2 className="mt-3 font-display text-3xl font-bold sm:text-4xl">
              Every module runs <span className="neon-text">on your silicon</span>
            </h2>

            <div id="budgeting" className="mt-10 grid gap-6 lg:grid-cols-2">
              <BudgetHud />

              <div className="grid gap-6">
                <div className="glass-card p-7">
                  <p className="hud-label">Biometric Security Vault</p>
                  <div className="mt-5 flex items-center gap-5">
                    <div className="grid size-20 shrink-0 place-items-center rounded-2xl border border-primary/40 bg-primary/5 text-3xl shadow-[0_0_28px_color-mix(in_oklab,var(--primary)_30%,transparent)]">
                      🔒
                    </div>
                    <div className="min-w-0">
                      <h3 className="text-lg font-semibold">Fingerprint & Face ID gate</h3>
                      <p className="mt-2 text-sm text-muted-foreground">
                        Purging data, editing history and CSV exports are locked behind your
                        device's secure enclave. Templates never touch the app.
                      </p>
                    </div>
                  </div>
                  <div className="mt-5 flex flex-wrap gap-2">
                    {["SECURE ENCLAVE", "NO TEMPLATE STORAGE", "OS-NATIVE PROMPT"].map((t) => (
                      <span
                        key={t}
                        className="rounded-full border border-border px-3 py-1 font-mono text-[10px] tracking-widest text-muted-foreground"
                      >
                        {t}
                      </span>
                    ))}
                  </div>
                </div>

                <div className="glass-card p-7">
                  <p className="hud-label">OCR Screenshot Parser</p>
                  <h3 className="mt-1 text-lg font-semibold">Scan a UPI receipt in one tap</h3>
                  <p className="mt-2 text-sm text-muted-foreground">
                    Watch how a GPay screenshot becomes a categorized transaction — all computed
                    locally.
                  </p>
                </div>
              </div>
            </div>

            <div className="mt-6">
              <CurrencyCalculator />
            </div>
          </section>

          {/* PRIVACY + TERMS */}
          <section className="mx-auto max-w-7xl px-5 py-20">
            <div className="grid gap-6 lg:grid-cols-[1.2fr_1fr]">
              <div className="glass-card p-7 sm:p-9">
                <p className="hud-label">Document / Legal</p>
                <h2 className="mt-3 font-display text-3xl font-bold">
                  Privacy <span className="neon-text">Policy</span>
                </h2>
                <div className="mt-7 max-h-[420px] overflow-y-auto pr-2">
                  <PrivacyContent />
                </div>
                <div className="mt-7 flex flex-wrap gap-3">
                  <button
                    type="button"
                    onClick={() => setPrivacy(true)}
                    className="rounded-full border border-primary/60 px-5 py-2.5 font-mono text-xs uppercase tracking-widest text-primary hover:bg-primary/10"
                  >
                    Open full policy
                  </button>
                  <Link
                    to="/privacy"
                    className="rounded-full border border-border px-5 py-2.5 font-mono text-xs uppercase tracking-widest text-muted-foreground hover:text-primary"
                  >
                    Dedicated page
                  </Link>
                </div>
              </div>

              <div className="glass-card p-7 sm:p-9">
                <p className="hud-label">Terms & System Info</p>
                <h2 className="mt-3 font-display text-2xl font-bold">Expency is a utility</h2>
                <p className="mt-3 text-sm leading-relaxed text-muted-foreground">
                  Expency is a personal finance utility — not a bank, payment processor, or
                  licensed financial advisor. All insights are informational only.
                </p>
                <ul className="mt-6 space-y-3">
                  {TERMS_SECTIONS.slice(0, 4).map((t) => (
                    <li key={t.title} className="border-l border-primary/40 pl-4">
                      <p className="font-mono text-[11px] tracking-widest text-primary">
                        {t.title}
                      </p>
                      <p className="mt-1 text-sm text-muted-foreground">{t.body[0]}</p>
                    </li>
                  ))}
                </ul>
                <Link
                  to="/terms"
                  className="mt-7 inline-block rounded-full border border-border px-5 py-2.5 font-mono text-xs uppercase tracking-widest text-muted-foreground hover:text-primary"
                >
                  Read full terms
                </Link>
              </div>
            </div>
          </section>

          {/* FAQ */}
          <section id="faq" className="mx-auto max-w-3xl px-5 py-20">
            <p className="hud-label">Frequently Asked</p>
            <h2 className="mt-3 font-display text-3xl font-bold sm:text-4xl">
              Questions from the <span className="neon-text">privacy-minded</span>
            </h2>
            <Accordion type="single" collapsible className="mt-8">
              {FAQS.map((f) => (
                <AccordionItem key={f.q} value={f.q} className="border-border">
                  <AccordionTrigger className="text-left text-base hover:text-primary hover:no-underline">
                    {f.q}
                  </AccordionTrigger>
                  <AccordionContent className="text-sm leading-relaxed text-muted-foreground">
                    {f.a}
                  </AccordionContent>
                </AccordionItem>
              ))}
            </Accordion>
          </section>

          {/* FINAL CTA */}
          <section className="mx-auto max-w-7xl px-5 pb-24">
            <div className="glass-card scanline p-10 text-center sm:p-16">
              <h2 className="font-display text-3xl font-bold sm:text-4xl">
                Your ledger. Your device. <span className="neon-text">Nobody else's.</span>
              </h2>
              <p className="mx-auto mt-4 max-w-xl text-sm text-muted-foreground">
                Install Expency and start tracking in under 30 seconds. No account, no cloud, no
                compromise.
              </p>
              <div className="mt-8 flex flex-wrap justify-center gap-4">
                <PlayStoreBadge />
              </div>
            </div>
          </section>
        </main>

        <SiteFooter />


        <Dialog open={privacy} onOpenChange={setPrivacy}>
          <DialogContent className="max-h-[85vh] max-w-2xl overflow-y-auto border-primary/30 bg-black/90 backdrop-blur-xl">
            <DialogHeader>
              <DialogTitle className="font-display text-2xl">
                Expency <span className="neon-text">Privacy Policy</span>
              </DialogTitle>
            </DialogHeader>
            <PrivacyContent />
          </DialogContent>
        </Dialog>
      </div>
    </CurrencyProvider>
  );
}
