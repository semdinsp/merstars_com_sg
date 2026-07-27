# Merstar International — Visual Refresh (v3)
Design document for development handoff · July 27, 2026

Same site structure and copy as merstar.com.sg — revised visual system, tuned for readability after customer feedback on v1, then refined after reviewing the v2 build.

## What changed since v2
- **Nav bar now matches the page background (Bone)**, not white. The white nav in the v2 build created a hard, jarring seam against the Bone hero right below it.
- **New: 4px gradient accent rule** (blue → green) runs full-width directly under the nav, in place of a plain hairline. It eases the nav-to-page transition and doubles as a small signature brand mark (the blue-to-green ribbon motif is used in Merstar's internal materials). Used sparingly — this is the only gradient on the page.
- Everything else from v2 (color system, section backgrounds, typography, components, accessibility) is unchanged and confirmed working in the live build.

## Customer feedback addressed
- v1: "Background seems too dark. Not readable." → fixed by making Bone/white the default background everywhere; dark Pine limited to top bar, footer, one CTA band.
- v2 review: white nav bar felt like a jarring seam against the Bone page. → fixed by matching nav to Bone + adding the gradient accent rule below it.

## Principles
- **Light by default** — Bone (#F5F3ED) or white carries every reading section. Dark green is a punctuation mark, not a backdrop.
- **One accent, used sparingly** — Signal green marks links, CTAs, and status — never large fills. The blue→green gradient is reserved for the single nav-divider rule only — do not repeat it elsewhere as a background or fill.
- **Editorial, not templated** — Fraunces serif headings and manifest-style data (route codes, numbered services) signal a 1989 freight house, not a generic template.
- **Accessible at every size** — all body/label text pairs meet WCAG AA (4.5:1); large display text meets 3:1 minimum.

## Color system
Contrast ratios computed against the background each color is meant to sit on.

| Color | Hex | Use | Contrast |
|---|---|---|---|
| Bone | #F5F3ED | Default page + nav background — hero, about, network, services, testimonials, contact | base |
| Ink | #17251E | Body text on Bone/white | 14.3:1 ✓ |
| Sage (text) | #4E5C54 | Secondary/muted copy, captions | 6.3:1 ✓ |
| Sage (decorative) | #8A9691 | Dividers, disabled states, icon strokes — never text under 24px | 2.8:1 — large/UI only |
| Signal green | #2FA35E | Button fills, status pills, icon accents — fills/large graphics only | 2.9:1 on Bone — fills only |
| Signal green (text/link) | #0E6E35 | Text links, small labels on Bone/white | 5.7:1 ✓ |
| Signal green (on dark) | #3DBE70 | Links/labels on Pine backgrounds | 6.5:1 ✓ |
| Pine | #0B2A1E | Top utility bar, one CTA band ("Enquiries for Partnership") | 15.4:1 (white text) ✓ |
| Pine deep | #081F16 | Footer only | 17.2:1 (white text) ✓ |
| Gradient accent (nav rule only) | linear-gradient(90deg, #2E6FD9, #2FA35E) | 4px rule directly under the nav — the one gradient on the page, never behind text | decorative only |

**Rule of thumb:** Dark (Pine / Pine deep) may only cover the top utility bar, the footer, and ONE CTA band. Every other section, including the nav, sits on Bone or white.

## Typography
- **Display / H1–H2:** Fraunces, weight 500 — 32–56px, 1.1 line-height
- **Body / UI:** IBM Plex Sans, 400/600 — 16–18px body, 1.6 line-height, never below 15px
- **Labels / data:** IBM Plex Mono — nav utility bar, section eyebrows, lane/status codes

## Section-by-section spec
- **Top utility bar** — Pine, slim (~36px). Email, phone, founding-member line.
- **Nav** — Bone (matches page), logo + links in Ink, active link underlined in Signal-text. "Request a Quote" button in Signal fill / Ink text. Followed immediately by the 4px blue→green gradient rule, full width.
- **Hero** — Bone. Fraunces headline, Ink text, no dark overlay. Right: white "Live Lane Status" manifest card with route rows and Signal status pills. Left: value bullets in Ink/Sage.
- **We Connect the World** — Bone. L.I.N.K network banner, thin Sage-decorative rules, Signal text link.
- **We Deliver With Care** — Bone. Strapline + single Signal-fill CTA button, Ink text.
- **About** — Bone / white card. 17px Ink body copy. Abstract route-graphic on white card, Signal "read more" link.
- **Our Network** — Bone. Mirrored route-graphic layout, Plex Mono region labels.
- **Our Services** — Bone. Numbered manifest list (01–08), Fraunces numerals in Sage-decorative, Ink titles, Sage-text descriptions.
- **Testimonials** — White card on Bone. Fraunces quote mark, Plex Mono attribution.
- **Enquiries CTA band** — Pine. The one full dark band. White heading/body, Signal-fill button, Ink text. One viewport-height max.
- **Contact** — Bone. Simple email/phone rows, Signal icon strokes, Ink labels.
- **Footer** — Pine deep. White/Bone text (17.2:1), Signal links only.

## Components
- **Primary button** — Signal green fill (#2FA35E), Ink text, 8px radius.
- **Secondary / text link** — Signal-text (#0E6E35), underline on hover; #3DBE70 on Pine.
- **Gradient accent rule** — 4px, blue (#2E6FD9) → green (#2FA35E), left to right. Used once, directly under the nav. Not a background, not repeated per-section.
- **Status pill** — Plex Mono, uppercase, 11px. "In transit" = Signal fill/Ink text; "Delivered/Cleared" = outline, Sage-text.
- **Cards** — White fill on Bone, 1px #D8D4C8 border, 8px radius, no drop shadow.

## Accessibility checklist
- Body copy minimum 15px; never render body text in Sage-decorative or Signal-fill shades.
- All text-on-color pairs above meet 4.5:1 (normal) or 3:1 (large/UI).
- Visible focus ring (2px Signal, 2px offset) on every link, button, and form field.
- Nav and buttons keep a 44px minimum hit target on mobile.
- Dark sections never nest another dark element inside them.

## Handoff notes for Claude Code
- This is a refinement of the already-implemented v2 build at merstars-com-sg.fly.dev — only the nav background and the new gradient rule need to change; everything else confirmed working, leave as-is.
- Nav background: change from white to Bone (#F5F3ED, matches page background — remove any distinct nav fill).
- Add a 4px full-width rule directly below the nav: `linear-gradient(90deg, #2E6FD9 0%, #2FA35E 100%)`. This is the only gradient anywhere on the site — do not use it as a section background or repeat it elsewhere.
- No other visual changes from the current live build.
