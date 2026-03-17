# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

The Growth Fuel — executive coaching website for Rethink Performance Sàrl, built with Zola (Rust-based static site generator) and Cloudflare Workers for the contact form API. Replaces a previous Wix site.

**Live site:** thegrowthfuel.com
**API endpoint:** api.thegrowthfuel.com/contact

## Build Commands

```bash
make dev              # Zola dev server with live reload (zola serve --open)
make build            # Production build to public/
make preview          # Build + serve locally on port 8000
make clean            # Remove public/
make design-system    # Open design system reference in browser
make dev-workers      # Run Cloudflare Workers locally (wrangler dev)
make deploy-workers   # Deploy Workers to Cloudflare
```

## Architecture

**Zola static site** with Tera templates, SCSS styling, and TOML data files:

- `content/` — Markdown pages with TOML frontmatter. Sections: services (private-sector, public-sector), programs (reignite, unlock-your-career, membership), about, contact, book-online, legal
- `templates/` — Tera templates. `base.html` is the master layout. `macros/` has reusable components (nav, footer, seo). `shortcodes/` has markdown-embeddable widgets (cta_button, calendly_inline, calendly_popup, testimonial, service_card, pricing_card, highlight_box, stats_row)
- `sass/` — SCSS with design token system in `_variables.scss`. Main entry: `main.scss` imports partials in cascade order
- `data/` — TOML data: `testimonials.toml` (client quotes), `services.toml` (service definitions)
- `static/` — Images (AVIF/WebP/SVG), fonts
- `workers/` — Cloudflare Workers backend for contact form email handling
- `design-system/` — Visual component reference and font comparison tool
- `current-site/` — Reference text content from the old Wix site

**Key config:** `zola.toml` holds site-wide settings including Calendly URLs, LinkedIn link, contact API endpoint, and brand entity name.

## Design System

- **Colors:** Purple primary (#41458E), Orange accent/CTA (#ED5E2D), Green secondary (#88C029), 9-step gray scale
- **Fonts:** Lora (serif, headings), Outfit (sans-serif, body) via Google Fonts
- **Spacing:** 8px base unit scale
- All tokens defined in `sass/_variables.scss`

## Conventions

- Static image paths use plain `/images/...` — do not use `get_url()` for static assets
- Content uses TOML frontmatter (not YAML)
- Zola compiles SASS automatically; no separate CSS build step needed
- Client-side JS is vanilla (no frameworks) — embedded in `base.html`

## Content Management

Content is managed directly via Claude Desktop (no CMS). The site owner describes changes in natural language and Claude edits the files, commits, and pushes to GitHub. Cloudflare then builds and deploys automatically.

**Editable content locations:**
- **Page text:** `content/` — Markdown files with TOML frontmatter. Each section has an `_index.md` and individual page files.
- **Testimonials:** `data/testimonials.toml` — Client quotes with name, role, and text fields.
- **Services:** `data/services.toml` — Service definitions used across the site.
- **Site settings:** `zola.toml` `[extra]` section — Calendly URLs, LinkedIn link, contact API endpoint, brand entity name.
- **Images:** `static/images/` — Use AVIF/WebP for photos, SVG for icons/logos.

**Deployment:** Push to GitHub → Cloudflare builds and deploys automatically.
