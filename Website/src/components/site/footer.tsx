import { Link } from "@tanstack/react-router";
import { PlayStoreBadge } from "./play-store-badge";

export function SiteFooter() {
  return (
    <footer className="border-t border-border bg-black/60 px-5 py-12">
      <div className="mx-auto flex max-w-7xl flex-col gap-8 md:flex-row md:items-start md:justify-between">
        <div className="max-w-sm space-y-4">
          <div className="flex items-center gap-2.5">
            <img src="/favicon.svg" alt="Expency Logo" className="size-6 rounded-md shadow-[0_0_10px_rgba(0,219,233,0.35)]" />
            <span className="font-display text-lg font-bold">EXPENCY</span>
            <span className="inline-block size-2 rounded-full bg-primary shadow-[0_0_12px_var(--primary)]" />
          </div>
          <p className="text-sm text-muted-foreground">
            A zero-cloud, fully on-device finance core. Your ledger never leaves your pocket.
          </p>
          <PlayStoreBadge />
          <span className="inline-flex items-center gap-2 rounded-full border border-primary/40 px-3 py-1.5 font-mono text-[11px] uppercase tracking-widest text-primary">
            🔒 Built for Privacy by Design
          </span>
        </div>

        <div className="grid grid-cols-2 gap-8 sm:grid-cols-3">
          <div className="space-y-2">
            <p className="hud-label">Product</p>
            <a href="/#features" className="block text-sm text-muted-foreground hover:text-primary">
              Features
            </a>
            <a
              href="/#budgeting"
              className="block text-sm text-muted-foreground hover:text-primary"
            >
              Budgeting
            </a>
            <a href="/#faq" className="block text-sm text-muted-foreground hover:text-primary">
              FAQ
            </a>
          </div>
          <div className="space-y-2">
            <p className="hud-label">Legal</p>
            <Link to="/privacy" className="block text-sm text-muted-foreground hover:text-primary">
              Privacy Policy
            </Link>
            <Link to="/terms" className="block text-sm text-muted-foreground hover:text-primary">
              Terms of Service
            </Link>
          </div>
          <div className="space-y-2">
            <p className="hud-label">Connect</p>
            <a
              href="https://github.com"
              target="_blank"
              rel="noreferrer noopener"
              className="block text-sm text-muted-foreground hover:text-primary"
            >
              GitHub Repo
            </a>
            <a href="/#faq" className="block text-sm text-muted-foreground hover:text-primary">
              Contact Support
            </a>
          </div>
        </div>
      </div>

      <div className="mx-auto mt-10 max-w-7xl border-t border-border pt-6">
        <p className="font-mono text-[11px] tracking-widest text-muted-foreground">
          COPYRIGHT © 2026 EXPENCY. ALL RIGHTS RESERVED.
        </p>
      </div>
    </footer>
  );
}
