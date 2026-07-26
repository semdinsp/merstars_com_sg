# Merstar International — Visual Refresh (v2)
Design document for development handoff · July 26, 2026

Same site structure and copy as merstar.com.sg — revised visual system, tuned for readability after customer feedback on v1.

## Customer feedback on v1
> "Background seems too dark. Not readable."

v1 used pine green as the default page background across hero, about, and network sections. This version flips that: **light (Bone) is the default background everywhere**. Pine is now reserved for three small, high-contrast moments — the top bar, the footer, and one CTA band — never for large reading surfaces.

## Principles
- **Light by default** — Bone (#F5F3ED) or white carries every reading section. Dark green is a punctuation mark, not a backdrop.
- **One accent, used sparingly** — Signal green marks links, CTAs, and status — never large fills. No green-on-green.
- **Editorial, not templated** — Fraunces serif headings and manifest-style data (route codes, numbered services) signal a 1989 freight house, not a generic template.
- **Accessible at every size** — all body/label text pairs meet WCAG AA (4.5:1); large display text meets 3:1 minimum.

## Color system
Contrast ratios computed against the background each color is meant to sit on.

| Color | Hex | Use | Contrast |
|---|---|---|---|
| Bone | #F5F3ED | Default page background — hero, about, network, services, testimonials, contact | base |
| Ink | #17251E | Body text on Bone/white | 14.3:1 ✓ |
| Sage (text) | #4E5C54 | Secondary/muted copy, captions — darkened from v1's #6E7C74 to clear AA | 6.3:1 ✓ |
| Sage (decorative) | #8A9691 | Dividers, disabled states, icon strokes — never text under 24px | 2.8:1 — large/UI only |
| Signal green | #2FA35E | Button fills, status pills, icon accents — fills/large graphics only | 2.9:1 on Bone — fills only |
| Signal green (text/link) | #0E6E35 | Text links, small labels on Bone/white | 5.7:1 ✓ |
| Signal green (on dark) | #3DBE70 | Links/labels on Pine backgrounds | 6.5:1 ✓ |
| Pine | #0B2A1E | Top bar, one CTA band ("Enquiries for Partnership") | 15.4:1 (white text) ✓ |
| Pine deep | #081F16 | Footer only | 17.2:1 (white text) ✓ |

**Rule of thumb:** Dark (Pine / Pine deep) may only cover the top bar, the footer, and ONE CTA band. Every other section sits on Bone or white. If a section needs emphasis, use a thin Signal-green rule, a numbered label, or a card border — not a dark fill.

## Typography
- **Display / H1–H2:** Fraunces, weight 500 — 32–56px, 1.1 line-height
- **Body / UI:** IBM Plex Sans, 400/600 — 16–18px body, 1.6 line-height, never below 15px
- **Labels / data:** IBM Plex Mono — nav utility bar, section eyebrows, lane/status codes

## Section-by-section spec
Same order and content as merstar.com.sg — background/treatment updated per section.

- **Top bar** — Pine. Slim utility strip: email, phone, "Request for Quote" button (Signal fill, Ink text). Main nav below on white with Pine text; active/hover underlines in Signal.
- **Hero** — Bone. "Your Partnership in Excellence" in Fraunces on Bone, Ink text, no dark overlay. Right side: a "Live Lane Status" manifest card (white, thin border) listing 2–3 routes (e.g. SIN → ICN) with small Signal status pills — replaces the old image carousel. Founding-member line and 4 value bullets sit left, in Ink/Sage.
- **We Connect the World** — Bone. L.I.N.K network banner. Light band, thin top/bottom rule in Sage-decorative, partner wordmark row, "read more" as a Signal text link.
- **We Deliver With Care** — Bone. "Logistics handlers since 1989" strapline, one sentence of copy, single Signal-fill CTA button ("Request for Quote") with Ink text for contrast.
- **About** — Bone / white card. Company copy at 17px Ink on Bone (was low-contrast on dark in v1). Right side: a simple canvas-drawn abstract cargo-route line graphic on a white card — replaces the empty image box — plus a "read more" Signal link.
- **Our Network** — Bone. Same abstract route-graphic treatment, mirrored layout. Regions listed as a Plex Mono label row (Asia · Pacific · Americas · Europe · Africa).
- **Our Services** — Bone. 8 services as a numbered manifest list (01–08) — large Fraunces numeral in Sage-decorative, service name in Ink, one-line description in Sage-text, thin divider between rows. Replaces circular icon placeholders. Whole row is a link; hover underlines the title in Signal.
- **Testimonials** — White card on Bone. 3 quotes in a light card carousel or stacked list, Fraunces italic-style quote mark, attribution in Plex Mono caps. No dark background — this is the section v1 users found hardest to read.
- **Enquiries CTA band** — Pine. The ONE full dark band on the page. White Fraunces heading, white body copy (15.4:1), Signal-fill button with Ink text. Short — one viewport-height max, not a full section stack.
- **Contact** — Bone. Email/phone as two simple rows with Signal-colored icon strokes, Ink labels. "Read more" Signal link to Contact Us page.
- **Footer** — Pine deep. Address, 3 phone lines, sitemap columns, accreditation logos (IATA/FIATA/ISO) recolored to sit cleanly on dark — white/Bone text at 17.2:1, Signal for links only.

## Components
- **Primary button** — Signal green fill (#2FA35E), Ink text (not white — white-on-Signal fails contrast), 8px radius, 14–16px padding-y. On a Pine background, same fill works with Ink text.
- **Secondary / text link** — Signal-text shade (#0E6E35) underlined on hover. On Pine, use the lighter #3DBE70 variant instead.
- **Status pill** (Live Lane Status card) — Plex Mono, uppercase, 11px. "In transit" = Signal-fill pill with Ink text; "Delivered"/"Scheduled" = outline pill, Sage-text label.
- **Cards** (testimonial, network, manifest) — White fill on Bone page background, 1px #D8D4C8 border, 8px radius, no drop shadow (keeps it flat/editorial rather than glossy-template).

## Accessibility checklist
- Body copy minimum 15px; never render body text in Sage-decorative or Signal-fill shades.
- All text-on-color pairs above meet 4.5:1 (normal text) or 3:1 (large/UI, 24px+/bold 19px+).
- Visible focus ring (2px Signal, 2px offset) on every link, button, and form field — v1 had none.
- Nav and buttons keep a 44px minimum hit target on mobile.
- Dark sections (top bar, footer, CTA band) never nest another dark element inside them — no dark-on-dark cards.

## Handoff notes for Claude Code
- Content, page structure, and nav hierarchy are unchanged from merstar.com.sg — this doc only changes visual treatment.
- Load Fraunces, IBM Plex Sans, and IBM Plex Mono from Google Fonts.
- Replace the old image carousel, circular service icons, and empty about/network image boxes per the section spec above — do not carry over v1's dark full-bleed section backgrounds.
- Real photography needed for: hero background texture (optional, light-toned), about-page team/warehouse photo. Everything else (manifest card, route graphics, service numbers) is drawn, not photographic.
- Flag any new page/section not listed here before building — this spec covers the current site's structure only.
