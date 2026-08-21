import { Link } from "@tanstack/react-router";
import { useEffect, useState } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";
import { PrivacyContent } from "./privacy-content";
import { CurrencySwitcher } from "./currency-switcher";

const LINKS = [
  { label: "Features", href: "/#features" },
  { label: "Privacy Architecture", href: "/#privacy-architecture" },
  { label: "Budgeting", href: "/#budgeting" },
  { label: "FAQ", href: "/#faq" },
];

export function SiteNav() {
  const [scrolled, setScrolled] = useState(false);
  const [open, setOpen] = useState(false);
  const [menu, setMenu] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 12);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <header
      className={`fixed inset-x-0 top-0 z-50 transition-all duration-300 ${
        scrolled ? "border-b border-border bg-black/80 backdrop-blur-xl" : "bg-transparent"
      }`}
    >
      <nav className="mx-auto grid max-w-7xl grid-cols-[minmax(0,1fr)_auto] items-center gap-4 px-5 py-3.5 lg:flex lg:justify-between">
        <Link to="/" className="flex min-w-0 items-center gap-2.5">
          <img src="/favicon.svg" alt="Expency Logo" className="size-7 rounded-lg shadow-[0_0_12px_rgba(0,219,233,0.4)]" />
          <span className="font-display text-lg font-bold tracking-tight text-foreground">
            EXPENCY
          </span>
          <span className="inline-block size-2 rounded-full bg-primary shadow-[0_0_12px_var(--primary)] pulse-dot" />
        </Link>

        <div className="hidden items-center gap-7 lg:flex">
          {LINKS.map((l) => (
            <a
              key={l.label}
              href={l.href}
              className="font-mono text-xs uppercase tracking-widest text-muted-foreground transition-colors hover:text-primary"
            >
              {l.label}
            </a>
          ))}
          <Link
            to="/privacy"
            className="font-mono text-xs uppercase tracking-widest text-muted-foreground transition-colors hover:text-primary"
          >
            Privacy Policy
          </Link>
        </div>

        <div className="flex items-center gap-3">
          <div className="hidden xl:block">
            <CurrencySwitcher compact />
          </div>
          <a
            href="#download"
            className="rounded-full border border-primary/60 bg-primary/10 px-4 py-2 font-mono text-xs uppercase tracking-widest text-primary transition-all hover:bg-primary/20 hover:shadow-[0_0_22px_color-mix(in_oklab,var(--primary)_45%,transparent)]"
          >
            Download App
          </a>
          <button
            type="button"
            aria-label="Toggle navigation menu"
            onClick={() => setMenu((v) => !v)}
            className="grid size-9 shrink-0 place-items-center rounded-md border border-border text-primary lg:hidden"
          >
            <span className="font-mono text-sm">{menu ? "×" : "≡"}</span>
          </button>
        </div>
      </nav>

      {menu ? (
        <div className="border-t border-border bg-black/95 px-5 py-4 lg:hidden">
          <div className="flex flex-col gap-3">
            {LINKS.map((l) => (
              <a
                key={l.label}
                href={l.href}
                onClick={() => setMenu(false)}
                className="font-mono text-xs uppercase tracking-widest text-muted-foreground"
              >
                {l.label}
              </a>
            ))}
            <Link
              to="/privacy"
              onClick={() => setMenu(false)}
              className="text-left font-mono text-xs uppercase tracking-widest text-muted-foreground"
            >
              Privacy Policy
            </Link>
            <div className="pt-2">
              <CurrencySwitcher compact />
            </div>
          </div>
        </div>
      ) : null}

      <Dialog open={open} onOpenChange={setOpen}>
        <DialogContent className="max-h-[85vh] max-w-2xl overflow-y-auto border-primary/30 bg-black/90 backdrop-blur-xl">
          <DialogHeader>
            <DialogTitle className="font-display text-2xl">
              Expency <span className="neon-text">Privacy Policy</span>
            </DialogTitle>
          </DialogHeader>
          <PrivacyContent />
        </DialogContent>
      </Dialog>
    </header>
  );
}
