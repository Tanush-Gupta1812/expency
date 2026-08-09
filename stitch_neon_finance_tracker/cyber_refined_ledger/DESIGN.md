---
name: Cyber-Refined Ledger
colors:
  surface: '#0d1515'
  surface-dim: '#0d1515'
  surface-bright: '#333b3b'
  surface-container-lowest: '#080f10'
  surface-container-low: '#151d1e'
  surface-container: '#192122'
  surface-container-high: '#232b2c'
  surface-container-highest: '#2e3637'
  on-surface: '#dce4e5'
  on-surface-variant: '#b9cacb'
  inverse-surface: '#dce4e5'
  inverse-on-surface: '#2a3233'
  outline: '#849495'
  outline-variant: '#3b494b'
  surface-tint: '#00dbe9'
  primary: '#dbfcff'
  on-primary: '#00363a'
  primary-container: '#00f0ff'
  on-primary-container: '#006970'
  inverse-primary: '#006970'
  secondary: '#c9c6c5'
  on-secondary: '#313030'
  secondary-container: '#4a4949'
  on-secondary-container: '#bab8b7'
  tertiary: '#f8f5f5'
  on-tertiary: '#313030'
  tertiary-container: '#dcd9d8'
  on-tertiary-container: '#5f5e5e'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#7df4ff'
  primary-fixed-dim: '#00dbe9'
  on-primary-fixed: '#002022'
  on-primary-fixed-variant: '#004f54'
  secondary-fixed: '#e5e2e1'
  secondary-fixed-dim: '#c9c6c5'
  on-secondary-fixed: '#1c1b1b'
  on-secondary-fixed-variant: '#474646'
  tertiary-fixed: '#e5e2e1'
  tertiary-fixed-dim: '#c8c6c5'
  on-tertiary-fixed: '#1c1b1b'
  on-tertiary-fixed-variant: '#474746'
  background: '#0d1515'
  on-background: '#dce4e5'
  surface-variant: '#2e3637'
typography:
  display-lg:
    fontFamily: Space Grotesk
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: 0.05em
  headline-sm:
    fontFamily: Space Grotesk
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: 0.1em
  body-lg:
    fontFamily: Space Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Space Grotesk
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Space Grotesk
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.15em
  headline-md-mobile:
    fontFamily: Space Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  container-padding: 20px
  stack-gap: 16px
  grid-gutter: 12px
---

## Brand & Style

This design system embodies a "High-Tech, Low-Life" aesthetic—a fusion of futuristic precision and moody, atmospheric depth. It targets tech-savvy power users who value both functional density and high-end visual flair.

The style is a hybrid of **Glassmorphism** and **Futuristic Minimalism**. It utilizes deep, pitch-black canvases to let vibrant neon accents and diffused glows command the user's attention. Key visual drivers include:
- **Luminosity:** Elements aren't just colored; they emit light.
- **Transparency:** Use of frosted glass textures to maintain a sense of layered complexity without clutter.
- **Precision:** Fine lines, technical monospaced vibes (via Space Grotesk), and strict grid alignment.

## Colors

The palette is anchored in absolute blacks to maximize the "pop" of the neon accents.

- **Primary (Neon Cyan):** Used for interactive states, key borders, and focus indicators. This color should always be paired with an outer glow (bloom) effect.
- **Surface (Deep Black):** `#0A0A0A` serves as the base background. 
- **Container (Glass):** Semi-transparent layers of `#1A1A1A` at 60-80% opacity with a `20px` backdrop blur.
- **Neutrals:** Grays are used sparingly for secondary text (e.g., `#666666`) to ensure the hierarchy remains clear.
- **Data Accents:** Vibrant purples, greens, and magentas are used for categorical data (like the breakdown chart) but remain secondary to the cyan brand color.

## Typography

This design system uses **Space Grotesk** across all levels to maintain a technical, geometric feel. 

- **Weight Contrast:** High contrast between Bold (700) for headers and Regular (400) for body text is essential for legibility against dark backgrounds.
- **Upper Case:** Use `label-caps` for section headers (e.g., "FINANCE_CORE") and secondary metadata to reinforce the system-interface aesthetic.
- **Letter Spacing:** Increase tracking on all-caps labels to improve readability and give a "pro" feel.

## Layout & Spacing

The layout follows a **Fixed-Width Fluid** model for mobile-first views, centered within the viewport for desktop. 

- **The 4px Rule:** All spacing increments must be multiples of 4px.
- **Density:** The design favors a medium-high density to present data-rich environments without feeling cramped.
- **Safe Margins:** A minimum of `20px` lateral padding is required for all screen sizes to keep content away from the bezel.
- **Sectioning:** Use vertical stacks with `16px` gaps between cards. Group related actions (like the Storage Sync list) with `1px` dividers or minimal `8px` spacing.

## Elevation & Depth

Depth is achieved through **Glassmorphism** and **Luminescence** rather than traditional shadows.

- **The Glow Effect:** Interactive cards and buttons feature a `0px 0px 15px` outer glow using the primary cyan color at 30% opacity.
- **Tiers of Surface:**
    - **Level 0 (Base):** Pitch black `#000000`.
    - **Level 1 (Card):** Semi-transparent `#1A1A1A` (80% opacity) with a `1px` border of cyan (20% opacity).
    - **Level 2 (Active/Hover):** Increase border opacity to 100% and add the primary glow.
- **Backdrop Blur:** A standard `20px` blur is applied to all container elements to ensure background textures (like the dot grid) do not interfere with text legibility.

## Shapes

The shape language is "Soft-Tech"—predominantly rounded to offset the coldness of the dark/neon color palette.

- **Standard Radius:** `8px` (base) for cards and primary buttons.
- **Small Radius:** `4px` for input fields and small chips.
- **Avatar:** Circular (pill) with a thick glowing border.
- **Borders:** Extremely fine (`1px` width). Never use thick borders as they detract from the "light-weight" glass aesthetic.

## Components

### Cards
Cards are the primary container. They feature a `1px` cyan border, often with a subtle linear gradient from top-left (Primary Cyan) to bottom-right (Transparent). Backgrounds must use backdrop-blur.

### Buttons & Chips
- **Primary Action:** Solid cyan background with black text. High glow intensity.
- **Secondary Action (Ghost):** Transparent background, cyan border, cyan text.
- **Filter Chips:** Pill-shaped. Active state is solid cyan; inactive is a dark gray-wash `#222`.

### Inputs
Search bars and text fields should be dark-recessed (`#000000`) with a subtle `1px` border. Use the `label-caps` style for placeholder text to match the technical vibe.

### Lists (Storage Sync Style)
List items within a card should have a dark background (`#111`) with a chevron-right icon for affordance. Use a thin `1px` divider of `#333` between items.

### Charts & Progress
Use vibrant, high-saturation colors for data points (e.g., `#FF00FF`, `#00FF00`). Progress bars should use the primary cyan with a trailing glow effect.