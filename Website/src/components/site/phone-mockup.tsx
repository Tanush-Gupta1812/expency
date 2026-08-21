import { formatCurrency } from "./currency";
import { useCurrency } from "./currency-context";

const ACTIVITY = [
  { name: "Blue Tokai Coffee", tag: "UPI · GPay", amount: -480, cat: "Food" },
  { name: "Salary Credit", tag: "NEFT · HDFC", amount: 62000, cat: "Income" },
  { name: "Netflix Premium", tag: "Auto-debit", amount: -649, cat: "Subs" },
  { name: "Uber Ride", tag: "UPI · PhonePe", amount: -237, cat: "Transport" },
];

export function PhoneMockup() {
  const { currency } = useCurrency();

  return (
    <div className="relative mx-auto w-full max-w-[330px] float-slow [perspective:1400px]">
      <div
        aria-hidden
        className="absolute -inset-10 -z-10 rounded-full blur-3xl"
        style={{
          background:
            "radial-gradient(circle, color-mix(in oklab, var(--primary) 28%, transparent) 0%, transparent 70%)",
        }}
      />
      <div className="rounded-[2.5rem] border border-primary/30 bg-black p-2 shadow-[0_0_60px_color-mix(in_oklab,var(--primary)_28%,transparent)] [transform:rotateY(-12deg)_rotateX(6deg)]">
        <div className="scanline overflow-hidden rounded-[2rem] border border-primary/15 bg-black dot-grid">
          <div className="flex items-center justify-between px-5 pt-4 font-mono text-[10px] text-muted-foreground">
            <span>09:41</span>
            <span className="flex items-center gap-1.5">
              <span className="inline-block size-1.5 rounded-full bg-income pulse-dot" />
              OFFLINE MODE
            </span>
          </div>

          <div className="space-y-4 p-5">
            <div>
              <p className="hud-label">Total Net Worth</p>
              <p className="mt-1 font-mono text-3xl font-bold text-foreground">
                {formatCurrency(322750, currency)}
              </p>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div className="rounded-lg border border-income/30 bg-income/5 p-3">
                <p className="font-mono text-[10px] tracking-widest text-income/80">INCOME</p>
                <p className="mt-1 font-mono text-sm font-semibold text-income">
                  {formatCurrency(45200, currency, true)}
                </p>
              </div>
              <div className="rounded-lg border border-expense/30 bg-expense/5 p-3">
                <p className="font-mono text-[10px] tracking-widest text-expense/80">EXPENSE</p>
                <p className="mt-1 font-mono text-sm font-semibold text-expense">
                  {formatCurrency(-12450, currency, true)}
                </p>
              </div>
            </div>

            <div className="rounded-lg border border-border bg-white/[0.02] p-3">
              <div className="flex items-center justify-between">
                <p className="hud-label">Monthly Budget HUD</p>
                <span className="font-mono text-[10px] text-warn">68%</span>
              </div>
              <div className="mt-2 h-1.5 w-full overflow-hidden rounded-full bg-white/10">
                <div
                  className="h-full rounded-full bg-warn shadow-[0_0_12px_color-mix(in_oklab,var(--warn)_60%,transparent)]"
                  style={{ width: "68%" }}
                />
              </div>
            </div>

            <div className="space-y-2">
              <p className="hud-label">Recent Activity</p>
              {ACTIVITY.map((t) => (
                <div
                  key={t.name}
                  className="flex items-center justify-between rounded-lg border border-white/5 bg-white/[0.02] px-3 py-2"
                >
                  <div className="min-w-0">
                    <p className="truncate text-xs font-medium text-foreground">{t.name}</p>
                    <p className="font-mono text-[10px] text-muted-foreground">{t.tag}</p>
                  </div>
                  <p
                    className={`shrink-0 pl-3 font-mono text-xs font-semibold ${
                      t.amount > 0 ? "text-income" : "text-expense"
                    }`}
                  >
                    {formatCurrency(t.amount, currency, true)}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
