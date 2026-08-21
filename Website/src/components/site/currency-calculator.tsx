import { useState } from "react";
import { CURRENCIES, CURRENCY_CODES, convertFromInr, type CurrencyCode } from "./currency";
import { useCurrency } from "./currency-context";

export function CurrencyCalculator() {
  const { currency, setCurrency } = useCurrency();
  const [amountInr, setAmountInr] = useState("4500");
  const value = Number(amountInr) || 0;

  return (
    <div className="glass-card p-6 sm:p-8">
      <p className="hud-label">Multi-Currency Engine</p>
      <h3 className="mt-1 text-xl font-semibold">Convert on the fly</h3>
      <p className="mt-2 text-sm text-muted-foreground">
        Track in any currency. Conversion runs locally — no exchange-rate API ever sees your
        ledger.
      </p>

      <div className="mt-6">
        <label htmlFor="amt" className="hud-label mb-2 block">
          Base amount (INR)
        </label>
        <div className="flex items-center gap-3 rounded-lg border border-input bg-black/60 px-4 py-3">
          <span className="font-mono text-lg text-primary">₹</span>
          <input
            id="amt"
            inputMode="decimal"
            value={amountInr}
            maxLength={12}
            onChange={(e) => setAmountInr(e.target.value.replace(/[^0-9.]/g, ""))}
            className="w-full bg-transparent font-mono text-lg text-foreground outline-none placeholder:text-muted-foreground"
            placeholder="0.00"
          />
        </div>
      </div>

      <div className="mt-6 grid gap-3 sm:grid-cols-2">
        {CURRENCY_CODES.map((code: CurrencyCode) => {
          const c = CURRENCIES[code];
          const active = code === currency;
          return (
            <button
              key={code}
              type="button"
              onClick={() => setCurrency(code)}
              className={`rounded-lg border px-4 py-3 text-left transition-all ${
                active
                  ? "border-primary/70 bg-primary/10 shadow-[0_0_20px_color-mix(in_oklab,var(--primary)_30%,transparent)]"
                  : "border-border bg-white/[0.02] hover:border-primary/40"
              }`}
            >
              <p className="font-mono text-[10px] tracking-widest text-muted-foreground">
                {code} · {c.label}
              </p>
              <p
                className={`mt-1 font-mono text-lg font-semibold ${
                  active ? "text-primary" : "text-foreground"
                }`}
              >
                {c.symbol}
                {convertFromInr(value, code).toLocaleString("en-US", {
                  minimumFractionDigits: c.decimals,
                  maximumFractionDigits: c.decimals,
                })}
              </p>
            </button>
          );
        })}
      </div>
      <p className="mt-4 font-mono text-[10px] tracking-widest text-muted-foreground">
        SELECTED DISPLAY CURRENCY: {currency} — APPLIED SITE-WIDE
      </p>
    </div>
  );
}
