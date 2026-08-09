---
name: Neon Ledger
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1b1b1b'
  surface-container: '#1f1f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#b9cac9'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#303030'
  outline: '#839493'
  outline-variant: '#3a4a49'
  surface-tint: '#00dddd'
  primary: '#ffffff'
  on-primary: '#003737'
  primary-container: '#00fbfb'
  on-primary-container: '#007070'
  inverse-primary: '#006a6a'
  secondary: '#ffabf3'
  on-secondary: '#5b005b'
  secondary-container: '#fe00fe'
  on-secondary-container: '#500050'
  tertiary: '#ffffff'
  on-tertiary: '#053900'
  tertiary-container: '#79ff5b'
  on-tertiary-container: '#117500'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#00fbfb'
  primary-fixed-dim: '#00dddd'
  on-primary-fixed: '#002020'
  on-primary-fixed-variant: '#004f4f'
  secondary-fixed: '#ffd7f5'
  secondary-fixed-dim: '#ffabf3'
  on-secondary-fixed: '#380038'
  on-secondary-fixed-variant: '#810081'
  tertiary-fixed: '#79ff5b'
  tertiary-fixed-dim: '#2ae500'
  on-tertiary-fixed: '#022100'
  on-tertiary-fixed-variant: '#095300'
  background: '#131313'
  on-background: '#e2e2e2'
  surface-variant: '#353535'
typography:
  display-lg:
    fontFamily: Space Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-mono:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-margin: 20px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

The design system is a fusion of **High-Contrast Dark Mode** and **Cyberpunk Glassmorphism**. It is engineered for a high-energy, futuristic financial experience that feels like a premium digital cockpit. 

The aesthetic prioritizes deep immersion using a pure black foundation to allow neon accents to "pop" with maximum luminance. It utilizes semi-transparent surfaces, ultra-fine glowing strokes, and diffused ambient light to create a sense of depth and technical sophistication. The emotional response should be one of empowerment, precision, and cutting-edge control over one's finances.

## Colors

The palette is anchored by a **Pure Black (#000000)** canvas to ensure infinite contrast ratios.

- **Primary (Neon Cyan):** Used for growth, positive balances, and primary actions.
- **Secondary (Electric Magenta):** Used for spending, alerts, and high-priority interactions.
- **Tertiary (Lime Green):** Used for success states, budgeting milestones, and secondary data visualizations.
- **Surface:** A deep charcoal (#0B0C10) is used for secondary layers to differentiate from the background.
- **Glows:** Every accent color has a corresponding 20% opacity glow used for shadows and border highlights.

## Typography

This design system utilizes a tiered typographic approach to reinforce the technical theme:
- **Headlines:** **Space Grotesk** provides a geometric, futuristic feel for large numerical displays and headers.
- **Body:** **Hanken Grotesk** ensures high readability for transaction lists and descriptions.
- **Labels/Data:** **JetBrains Mono** is used for transaction timestamps, ID numbers, and currency codes to evoke a "code-like" financial ledger aesthetic.

All primary text is pure white. Secondary text uses a muted slate gray to maintain hierarchy and reduce visual fatigue.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for Android handheld devices. 
- **Margins:** A fixed 20px horizontal margin ensures content does not bleed into edge-to-edge screen curvatures.
- **Rhythm:** An 8px linear scale governs all padding and margins.
- **Mobile First:** On mobile, components occupy full width or split 50/50. As screen real estate increases, cards transition into a multi-column masonry layout to preserve information density.

## Elevation & Depth

Depth is conveyed through **Glassmorphism** rather than traditional shadows.
- **Level 0:** Pure Black background.
- **Level 1:** Semi-transparent Black (#000000 at 60% opacity) with a 16px background blur (Backdrop Filter).
- **Strokes:** Every elevated surface must have a 1px solid border. The border should use a linear gradient: top-left (accent color at 50% opacity) to bottom-right (accent color at 10% opacity).
- **Glow:** Active elements (like the current balance card) feature an external "Outer Glow"—a drop shadow with 0px offset and 12px blur using the primary accent color at 30% opacity.

## Shapes

The design system adopts a **Rounded** philosophy to soften the aggressive neon aesthetic.
- **Standard Cards:** 24px corner radius (`rounded-xl`).
- **Buttons & Inputs:** 16px corner radius (`rounded-lg`).
- **Chips/Badges:** Fully rounded (pill-shaped).
- **Inner Elements:** Elements nested inside cards should use a slightly smaller radius (12px) to maintain visual nesting harmony.

## Components

### Buttons
Primary buttons are solid Neon Cyan with black text. Secondary buttons are "Ghost" style: transparent background with a neon border and an inner glow on hover/press.

### Glass Cards
The core container for the expense tracker. Must include a 1px glowing border and a subtle noise texture overlay (3% opacity) to enhance the "glass" realism.

### Bottom Navigation
A fixed-position bar with a `Backdrop Filter: blur(20px)` and a 2px Neon Cyan top border. Icons use a "Dual-Tone" style where the active state features a glowing aura behind the icon.

### Input Fields
Inputs are dark charcoal with a 1px bottom border. When focused, the bottom border expands to 2px and emits a neon glow corresponding to the input type (Cyan for Income, Magenta for Expense).

### Chips & Tags
Small, high-contrast badges for categories (e.g., "Food", "Tech"). These use a low-opacity fill of the accent color with a high-saturation text label.

### Transaction Lists
List items are separated by subtle 0.5px dimmed borders. Each item features a leading "Category Icon" encased in a circular glass container.