import { CURRENCIES, CURRENCY_CODES } from "./currency";
import { useCurrency } from "./currency-context";

export function CurrencySwitcher({ compact = false }: { compact?: boolean }) {
  const { currency, setCurrency } = useCurrency();

  return (
    <div
      role="group"
      aria-label="Select display currency"
      className="inline-flex items-center gap-1 rounded-full border border-border bg-black/60 p-1 backdrop-blur-md"
    >
      {CURRENCY_CODES.map((code) => {
        const active = code === currency;
        return (
          <button
            key={code}
            type="button"
            onClick={() => setCurrency(code)}
            aria-pressed={active}
            className={`rounded-full px-3 py-1.5 font-mono text-xs transition-all ${
              active
                ? "bg-primary/15 text-primary shadow-[0_0_18px_color-mix(in_oklab,var(--primary)_35%,transparent)]"
                : "text-muted-foreground hover:text-foreground"
            }`}
          >
            {CURRENCIES[code].symbol}
            {compact ? "" : ` ${code}`}
          </button>
        );
      })}
    </div>
  );
}
