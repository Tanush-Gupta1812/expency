import { createContext, useContext, useMemo, useState, type ReactNode } from "react";
import type { CurrencyCode } from "./currency";

type Ctx = { currency: CurrencyCode; setCurrency: (c: CurrencyCode) => void };

const CurrencyContext = createContext<Ctx>({ currency: "INR", setCurrency: () => {} });

export function CurrencyProvider({ children }: { children: ReactNode }) {
  const [currency, setCurrency] = useState<CurrencyCode>("INR");
  const value = useMemo(() => ({ currency, setCurrency }), [currency]);
  return <CurrencyContext.Provider value={value}>{children}</CurrencyContext.Provider>;
}

export function useCurrency() {
  return useContext(CurrencyContext);
}
