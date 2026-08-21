# Cyber Budget Hub

Build a modern, high-converting, dark-mode landing page and web application for "Expency" — an ultra-private, fully local, cyberpunk-themed expense tracker app.

### 1. BRANDING & AESTHETICS

- **Vibe:** Cyberpunk, Minimalist Tech, Digital Sanctuary HUD ("FINANCE_CORE").

- **Colors:**

  - Background: Pitch Black (`#000000`) with subtle dot-matrix grid pattern.

  - Primary Accent: Neon Cyan (`#00DBE9`) with ambient glow effects and neon borders.

  - Secondary Accents: Electric Lime Green (`#00FF00` for Income) and Electric Magenta (`#FF00FF` for Expense).

  - Tonal Surfaces: Glassmorphic dark cards (`rgba(26, 26, 26, 0.6)`) with 1px neon borders and soft blur (`backdrop-blur-md`).

- **Typography:** Space Grotesk / Inter (monospace accents for monetary figures).

---

### 2. PAGE STRUCTURE & SECTIONS

#### A. HEADER & HERO SECTION

- **Navbar:** Logo ("EXPENCY" with neon cyan dot), Links (Features, Privacy Architecture, Budgeting, FAQ, Privacy Policy), and a CTA button ("Download App" / "Get Started").

- **Hero Headline:** "Take Absolute Control of Your Money. Zero Cloud. Zero Tracking."

- **Subheadline:** "A high-performance, fully on-device expense manager with smart receipt screenshot scanning, dynamic budget alerts, and zero data leakage."

- **CTAs:** 

  - Primary: "Download APK / Get on Android" (with Google Play / GitHub badges)

  - Secondary: "Explore Features" (smooth scroll)

- **Visual Mockup:** Interactive 3D/glow mockup of the app dashboard showing the Total Net Worth balance card (`+₹45,200.00` in Neon Green, `-₹12,450.00` in Electric Magenta) and recent activity items.

#### B. VALUE PROPOSITION: "THE ZERO-CLOUD DIFFERENCE"

A 3-column comparison grid highlighting:

1. **100% On-Device Local Storage:** No servers, no signups, no database leaks. Your financial data never leaves your phone.

2. **On-Device OCR Screenshot Parsing:** Snap or screenshot any UPI / Bank transaction (GPay, PhonePe, Paytm), and ML Kit instantly extracts the recipient and amount locally.

3. **Adaptive Budget HUD:** Dynamic interface colors that shift from Neon Cyan → Warning Yellow → Critical Orange → Red as you approach your spending limits.

#### C. INTERACTIVE FEATURE SHOWCASE

- **Smart Category & Budget Limits:** Visual breakdown cards for Food & Dining, Shopping, Subscriptions, Transport, etc., with live progress indicators.

- **Biometric Security Vault:** Visual showing fingerprint/Face ID protection for sensitive actions.

- **Interactive Multi-Currency Calculator:** A live demo widget where visitors can toggle between USD ($), INR (₹), EUR (€), GBP (£), and JPY (¥).

#### D. PRIVACY POLICY MODAL / DEDICATED PAGE

Include a dedicated section/modal with the full Privacy Policy:


EXPENCY PRIVACY POLICY Last Updated: August 2026

OUR CORE PROMISE Expency was engineered from the ground up with a strict "No Cloud, No Tracking" architecture. We do not operate user accounts, remote databases, or telemetry servers.

DATA COLLECTION & STORAGE

All transaction records, categories, budget limits, and user preferences are stored exclusively on your device's local sandboxed storage (SharedPreferences / Local Database).
We do not collect, transmit, sell, or analyze your personal, financial, or behavioral data.
CAMERA & PHOTO ACCESS (OCR PROCESSING)
Expency requests access to your photos/storage solely for the purpose of selecting screenshots or receipts for transaction extraction.
Text recognition is executed 100% on-device using local machine learning models (Google ML Kit). No images or OCR text are uploaded to the cloud.
BIOMETRIC DATA
Expency integrates with your operating system's native biometric authentication (Biometrics / Face ID / Fingerprint) to protect destructive actions.
Expency does not have access to or store your biometric templates; verification is handled entirely by the secure enclave of your device OS.
THIRD-PARTY SERVICES & ANALYTICS
Expency contains NO third-party advertising SDKs, tracking pixels, analytics trackers (such as Google Analytics or Firebase), or crash reporters that exfiltrate data.
DATA DELETION
You have full ownership of your data. You can delete individual transactions or permanently purge all stored data via Profile > Clear All Local Data at any time.
CONTACT
For inquiries regarding privacy:  (leave it as of now)

#### E. TERMS OF SERVICE & SYSTEM INFO
- Standard terms defining that Expency is a personal finance utility and not a bank or licensed financial advisor.
#### F. FAQ SECTION
- *Q: Does Expency link to my bank account?* (A: No, avoiding any third-party credentials or Open Banking APIs for maximum security).
- *Q: Can I backup my data?* (A: Yes, via CSV export and local device backups).
- *Q: Is the screenshot parser sending my images online?* (A: No, parsing is executed entirely locally on your processor).
#### G. FOOTER
- Copyright © 2026 Expency. All rights reserved.
- Links: GitHub Repo, Privacy Policy, Terms of Service, Contact Support.
- Badge: "🔒 Built for Privacy by Design".
---
### 3. INTERACTIVE TOUCHES & MICRO-INTERACTIONS
- Subtle cursor glowing trail or neon gradient hover states on cards (`box-shadow: 0 0 20px rgba(0, 219, 233, 0.3)`).
- Working currency switcher in the navbar or hero demo widget.
- Smooth modal transitions for Privacy Policy and screenshot scanner demo.
1:03 PM

This project was built with [Lovable](https://lovable.dev).

## Build with Lovable

Continue developing this project in the [Lovable editor](https://lovable.dev/projects/065f9115-3407-454c-86b0-0bd68f96fe9d).

- **Ship faster**: describe what you want to build and Lovable handles the code.
- **Stay in sync**: every change made in Lovable is committed straight to this repository.
- **Full ownership**: this code is yours. Push to `main` on GitHub and your changes sync back into Lovable, ready for your next prompt.

## Development

Prefer working locally? You need Node.js and npm — [install with nvm](https://github.com/nvm-sh/nvm#installing-and-updating).

```sh
git clone <this-repository-url>
cd <repository-name>
npm i
npm run dev
```
