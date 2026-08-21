export type CurrencyCode = "INR" | "USD" | "EUR" | "GBP" | "JPY";

export const CURRENCIES: Record<
  CurrencyCode,
  { symbol: string; label: string; rateFromInr: number; decimals: number }
> = {
  INR: { symbol: "₹", label: "Indian Rupee", rateFromInr: 1, decimals: 2 },
  USD: { symbol: "$", label: "US Dollar", rateFromInr: 0.0115, decimals: 2 },
  EUR: { symbol: "€", label: "Euro", rateFromInr: 0.0106, decimals: 2 },
  GBP: { symbol: "£", label: "Pound Sterling", rateFromInr: 0.009, decimals: 2 },
  JPY: { symbol: "¥", label: "Japanese Yen", rateFromInr: 1.72, decimals: 0 },
};

export const CURRENCY_CODES = Object.keys(CURRENCIES) as CurrencyCode[];

export function convertFromInr(amountInr: number, code: CurrencyCode) {
  return amountInr * CURRENCIES[code].rateFromInr;
}

export function formatCurrency(amountInr: number, code: CurrencyCode, signed = false) {
  const c = CURRENCIES[code];
  const value = convertFromInr(Math.abs(amountInr), code);
  const formatted = value.toLocaleString("en-US", {
    minimumFractionDigits: c.decimals,
    maximumFractionDigits: c.decimals,
  });
  const sign = signed ? (amountInr < 0 ? "-" : "+") : amountInr < 0 ? "-" : "";
  return `${sign}${c.symbol}${formatted}`;
}
