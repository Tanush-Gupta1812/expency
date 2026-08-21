import { Play } from "lucide-react";

export function PlayStoreBadge({
  href = "https://play.google.com/store/apps/details?id=app.expency.finance",
  className = "",
}: {
  href?: string;
  className?: string;
}) {
  return (
    <a
      href={href}
      target="_blank"
      rel="noreferrer noopener"
      aria-label="Get Expency on Google Play Store"
      className={`group inline-flex items-center gap-3 rounded-xl border border-[#A6A6A6] bg-black px-4 py-2.5 transition-all hover:border-primary hover:shadow-[0_0_22px_color-mix(in_oklab,var(--primary)_45%,transparent)] ${className}`}
    >
      <Play className="size-6 fill-current text-primary transition-colors group-hover:text-white" />
      <div className="text-left">
        <p className="font-sans text-[10px] leading-none text-muted-foreground">GET IT ON</p>
        <p className="font-sans text-base font-semibold leading-none text-white">Google Play</p>
      </div>
    </a>
  );
}
