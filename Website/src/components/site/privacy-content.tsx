const SECTIONS: { title: string; body: string[] }[] = [
  {
    title: "01 / Introduction",
    body: [
      "This Privacy Policy explains how Expency (\"we\", \"our\" or \"the app\") handles information when you use our mobile application. By installing and using Expency, you agree to the practices described in this policy.",
      "If you do not agree with this policy, please do not install or use the app.",
    ],
  },
  {
    title: "02 / Data Collection & Storage",
    body: [
      "Expency does not collect, transmit, store, or share your personal or financial information on any remote server.",
      "All transaction records, categories, budget limits, preferences, and any images you select for on-device OCR are stored exclusively in your device's local sandboxed storage (SharedPreferences / local database).",
      "We do not use any advertising SDKs, analytics trackers, telemetry services, or third-party services that access your data.",
    ],
  },
  {
    title: "03 / Permissions We Request",
    body: [
      "Camera / Photos / Media (optional): Used only to let you select screenshots or receipts for local OCR processing. We never upload images or OCR results.",
      "Biometric authentication (optional): Used to protect sensitive actions such as deleting data or exporting data. Your biometric data is handled entirely by your device's operating system and secure hardware; we never access, store, or transmit it.",
      "No other permissions are required. Expency does not access your contacts, location, microphone, SMS, phone state, or network accounts.",
    ],
  },
  {
    title: "04 / How We Use Your Data",
    body: [
      "Because everything is stored locally, we do not use your data for advertising, analytics, profiling, or any purpose beyond the core functionality of the app.",
      "OCR text recognition is performed 100% on-device using local machine learning models. No image or extracted text is sent to the cloud.",
    ],
  },
  {
    title: "05 / Data Sharing & Disclosure",
    body: [
      "We do not share, sell, rent, or disclose your information to any third party.",
      "Expency has no backend servers, no user accounts, and no data transfers to external services.",
    ],
  },
  {
    title: "06 / Data Security",
    body: [
      "Your data is protected by your device's own operating system security and sandboxing. We recommend that you enable device-level encryption, screen lock, and biometric unlock for additional protection.",
      "Sensitive actions within the app can be locked behind your device's biometric prompt.",
    ],
  },
  {
    title: "07 / Data Retention & Deletion",
    body: [
      "You have full control over your data. You can delete individual transactions or permanently clear all stored data via the app settings at any time.",
      "Uninstalling the app or wiping your device will remove all local data stored by Expency. We do not retain any copies because no data is stored remotely.",
    ],
  },
  {
    title: "08 / Children's Privacy",
    body: [
      "Expency is not intended for children under the age of 13. We do not knowingly collect any information from children.",
      "If you believe a child has provided information to us, please contact us so we can assist.",
    ],
  },
  {
    title: "09 / International Users",
    body: [
      "Expency operates entirely offline. Because no data leaves your device, your information remains within your jurisdiction and under your control.",
    ],
  },
  {
    title: "10 / Changes to This Policy",
    body: [
      "We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated \"Last Updated\" date. Continued use of the app after changes constitutes acceptance of the revised policy.",
    ],
  },
  {
    title: "11 / Contact Us",
    body: [
      "If you have any questions about this Privacy Policy or how your data is handled, please contact us at: privacy@expency.app",
    ],
  },
];

export function PrivacyContent() {
  return (
    <div className="space-y-7">
      <p className="hud-label">Last Updated: August 2026</p>
      {SECTIONS.map((s) => (
        <section key={s.title} className="space-y-2">
          <h3 className="font-mono text-sm font-semibold tracking-wider text-primary">
            {s.title}
          </h3>
          {s.body.map((p, idx) => (
            <p key={`${s.title}-${idx}`} className="text-sm leading-relaxed text-muted-foreground">
              {p}
            </p>
          ))}
        </section>
      ))}
    </div>
  );
}

export const TERMS_SECTIONS: { title: string; body: string[] }[] = [
  {
    title: "01 / Nature of the Service",
    body: [
      "Expency is a personal finance utility. It is not a bank, payment processor, broker, or licensed financial advisor, and it holds no funds on your behalf.",
    ],
  },
  {
    title: "02 / No Financial Advice",
    body: [
      "Budgets, category insights and totals shown in Expency are informational only. You are solely responsible for financial decisions made using the app.",
    ],
  },
  {
    title: "03 / Accuracy & OCR",
    body: [
      "On-device screenshot parsing is a convenience feature. Extracted amounts, recipients and dates may be imperfect and should be reviewed before saving.",
    ],
  },
  {
    title: "04 / Your Data, Your Responsibility",
    body: [
      "Because Expency stores everything locally, uninstalling the app, wiping the device, or clearing local data permanently removes your records. Export CSV backups regularly.",
    ],
  },
  {
    title: "05 / Warranty & Liability",
    body: [
      'The app is provided "as is" without warranties of any kind. To the maximum extent permitted by law, the developers are not liable for any loss arising from use of the app.',
    ],
  },
  {
    title: "06 / System Info",
    body: [
      "Requirements: Android 8.0+ · ~14 MB install size · Offline runtime · No account required · Permissions: photos/storage (optional), biometrics (optional).",
    ],
  },
];
