import { useEffect, useRef } from "react";

export function CursorGlow() {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    if (window.matchMedia("(pointer: coarse)").matches) return;

    let x = window.innerWidth / 2;
    let y = window.innerHeight / 2;
    let tx = x;
    let ty = y;
    let moving = false;
    let rafId: number | null = null;

    const tick = () => {
      x += (tx - x) * 0.15;
      y += (ty - y) * 0.15;
      el.style.transform = `translate3d(${x - 150}px, ${y - 150}px, 0)`;

      if (Math.abs(tx - x) > 0.5 || Math.abs(ty - y) > 0.5) {
        rafId = requestAnimationFrame(tick);
      } else {
        moving = false;
      }
    };

    const onMove = (e: MouseEvent) => {
      tx = e.clientX;
      ty = e.clientY;
      el.style.opacity = "1";
      if (!moving) {
        moving = true;
        rafId = requestAnimationFrame(tick);
      }
    };

    window.addEventListener("mousemove", onMove, { passive: true });
    return () => {
      window.removeEventListener("mousemove", onMove);
      if (rafId) cancelAnimationFrame(rafId);
    };
  }, []);

  return (
    <div
      ref={ref}
      aria-hidden
      className="pointer-events-none fixed left-0 top-0 z-0 h-[300px] w-[300px] rounded-full opacity-0 transition-opacity duration-300 will-change-transform"
      style={{
        background:
          "radial-gradient(circle, color-mix(in oklab, var(--primary) 18%, transparent) 0%, transparent 70%)",
      }}
    />
  );
}
