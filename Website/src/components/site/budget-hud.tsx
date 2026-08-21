import { useState } from "react";
import { formatCurrency } from "./currency";
import { useCurrency } from "./currency-context";

const CATEGORIES = [
  { name: "Food & Dining", limit: 12000, spent: 5400, icon: "🍜" },
  { name: "Shopping", limit: 9000, spent: 6600, icon: "🛍️" },
  { name: "Subscriptions", limit: 3000, spent: 2600, icon: "📺" },
  { name: "Transport", limit: 5000, spent: 4750, icon: "🚕" },
];

function statusOf(pct: number) {
  if (pct < 50) return { label: "NOMINAL", color: "var(--primary)" };
  if (pct < 75) return { label: "WARNING", color: "var(--warn)" };
  if (pct < 92) return { label: "CRITICAL", color: "var(--critical)" };
  return { label: "BREACH", color: "var(--danger)" };
}

export function BudgetHud() {
  const { currency } = useCurrency();
  const [intensity, setIntensity] = useState(100);

  return (
    <div className="glass-card p-6 sm:p-8">
      <div className="grid grid-cols-[minmax(0,1fr)_auto] items-center gap-4">
        <div className="min-w-0">
          <p className="hud-label">Adaptive Budget HUD</p>
          <h3 className="mt-1 truncate text-xl font-semibold">Smart category limits</h3>
        </div>
        <span className="shrink-0 font-mono text-[11px] text-muted-foreground">LIVE</span>
      </div>

      <div className="mt-6 space-y-5">
        {CATEGORIES.map((c) => {
          const spent = (c.spent * intensity) / 100;
          const pct = Math.min(150, (spent / c.limit) * 100);
          const s = statusOf(pct);
          return (
            <div key={c.name} className="space-y-2">
              <div className="flex items-baseline justify-between gap-3">
                <span className="min-w-0 truncate text-sm text-foreground">
                  <span className="mr-2">{c.icon}</span>
                  {c.name}
                </span>
                <span className="shrink-0 font-mono text-xs" style={{ color: s.color }}>
                  {formatCurrency(spent, currency)} / {formatCurrency(c.limit, currency)}
                </span>
              </div>
              <div className="h-2 w-full overflow-hidden rounded-full bg-white/8">
                <div
                  className="h-full rounded-full transition-all duration-500"
                  style={{
                    width: `${Math.min(100, pct)}%`,
                    background: s.color,
                    boxShadow: `0 0 14px ${s.color}`,
                  }}
                />
              </div>
              <p className="font-mono text-[10px] tracking-widest" style={{ color: s.color }}>
                {s.label} · {Math.round(pct)}%
              </p>
            </div>
          );
        })}
      </div>

      <div className="mt-7 border-t border-border pt-5">
        <label
          htmlFor="spend-intensity"
          className="hud-label mb-3 block"
        >
          Simulate spending intensity
        </label>
        <input
          id="spend-intensity"
          type="range"
          min={20}
          max={160}
          value={intensity}
          onChange={(e) => setIntensity(Number(e.target.value))}
          className="w-full accent-[var(--primary)]"
        />
      </div>
    </div>
  );
}
