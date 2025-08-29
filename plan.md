# Block Expansion Plan for Bootstrap + 11ty + Sanity (with Rich Text)

## Objectives
- Expand reusable page blocks to cover common landing-page needs while staying faithful to Bootstrap 5.3 patterns.
- Add corresponding Sanity schema types so editors can assemble pages visually (block-by-block).
- Support rich formatted copy inside blocks using Sanity Portable Text.
- Keep the data shape simple and map cleanly to 11ty/Nunjucks includes.

## Current State (as of repo)
- Existing blocks in `bootstrap/web/src/_includes/blocks`:
  - `header.njk`, `imageWithCaption.njk`, `twoColumnText.njk`.
- Sanity document `landingPage` with `blocks[]` containing: `header`, `imageWithCaption`, `twoColumnText`.
- `landing.njk` iterates blocks by `_type` and includes `blocks/<type>.njk`.
- Bootstrap assets loaded via CDN in `base.njk` (CSS + JS bundle), so interactive components (accordion, collapse, etc.) are available.

## Selection From Bootstrap 5.3.8 Examples
The following additions are chosen for broad landing-page coverage using canonical Bootstrap patterns. Each item lists: purpose, example source, Sanity fields (draft), and notes for the Nunjucks include.

1) heroCover
- Purpose: Primary hero with headline, lead, and CTAs; optional background image.
- Example: `bootstrap-5.3.8-examples/cover` or `heroes` (centered variants).
- Sanity fields: `title (string)`, `lead (portableText)`, `bgImage (image)`, `align (string: 'center'|'start'|'end')`, `buttons (array of {label,url,style('primary'|'secondary'|'link')})`.
- Template: Full-width section with optional background image, centered layout by default; outputs up to two CTAs.

2) featuresGrid
- Purpose: Grid of features (icon/title/text) in 3–4 columns.
- Example: `bootstrap-5.3.8-examples/features`.
- Sanity fields: `title (string)`, `intro (portableText)`, `columns (number: 2|3|4)`, `items (array of {icon (string; Bootstrap icon name or emoji), title (string), text (portableText), url (url, optional)})`.
- Template: Responsive `row` with `col-md-*` based on `columns`; optional link per item.

3) cardsGrid
- Purpose: Cards with image, title, text, link; useful for resources, posts, projects.
- Example: `bootstrap-5.3.8-examples/album`.
- Sanity fields: `title (string)`, `intro (portableText)`, `cards (array of {image (image), title (string), text (portableText), url (url)})`.
- Template: Cards in a responsive grid; gracefully handles missing images (show placeholder alert like current `imageWithCaption`).

4) pricingTable
- Purpose: Pricing plans with features and CTA buttons.
- Example: `bootstrap-5.3.8-examples/pricing`.
- Sanity fields: `title (string)`, `subtitle (portableText)`, `plans (array of {name, price (string), period (string), features (array of portableText or string), highlight (boolean), buttonLabel (string), buttonUrl (url)})`.
- Template: 3–4 column plans; apply `highlight` plan with a border or background emphasis.

5) faqAccordion
- Purpose: FAQ with collapsible questions/answers.
- Example: Bootstrap Accordion pattern (used across examples; see `components` in docs, also present in examples).
- Sanity fields: `title (string)`, `items (array of {question (string), answer (portableText)})`.
- Template: One `accordion` per block with unique ID; each item an `accordion-item`.

6) ctaBanner
- Purpose: Eye-catching call-to-action banner between sections.
- Example: `jumbotron`/`cover` patterns adapted as compact banner.
- Sanity fields: `title (string)`, `text (portableText)`, `buttonLabel (string)`, `buttonUrl (url)`, `variant (string: 'primary'|'secondary'|'light'|'dark')`.
- Template: Full-width `container-fluid` or `container` with background variant; one primary CTA.

(Keep existing)
7) header (existing)
- Purpose: Page header with simple nav (already implemented).

8) imageWithCaption (existing)
- Purpose: Figure with image, alt, caption (already implemented). Consider switching `caption` to `portableText` for rich captions.

9) twoColumnText (existing)
- Purpose: Two text columns for copy/layout (already implemented). Migrate `left` and `right` from HTML `text` to `portableText` (support both during transition).

Notes on omitted items (for scope):
- Carousel: powerful but heavier editorial model (captions, intervals); can be added later if needed.
- Footers/Navbars: generally belong to layout; keep out of per-page blocks for now.

## Data Modeling Conventions
- Block naming: Sanity `_type` matches Nunjucks include filename (e.g., `_type: 'heroCover'` -> `blocks/heroCover.njk`).
- Images: Use Sanity `image` type. In GROQ, expand `image.asset->url` (and `alt` string) similar to current `imageWithCaption`. Prefer a consistent property name (`url`) for templates.
- Rich text: Use a shared `portableText` object schema for formatted copy. Enable headings (h2–h4), lists, links (with `rel`/`target`), bold/italic, and code where helpful. Short fields that must remain single-line can stay as `string`.
- Booleans/enums: Favor simple string enums for variants (e.g., `'primary'|'secondary'`).
- Previews: Add `preview` to schema types for authoring clarity (title + short subtitle).

## Rendering Conventions (Nunjucks)
- Wrapper: Use `.container` for normal sections; `.container-fluid` for full-bleed when visually useful (e.g., `heroCover`, `ctaBanner`).
- Spacing: Apply consistent vertical rhythm (`py-5`, `my-5`) per section for coherent stacking.
- Portable Text rendering: Render PT arrays to HTML via a Nunjucks filter `pt`. Example: `{{ block.lead | pt | safe }}`.
- Safety: Guard for missing optional fields; sanitize/normalize external links (e.g., add `rel="noopener"` on `target=_blank`).
- Accessibility: Always surface `alt` for images; use semantic headings and button `aria-label` where appropriate.

### Nunjucks Compatibility Rules (to avoid regressions)
- No JavaScript-style ternaries or property access in expressions: avoid `cond ? a : b` and `array.length`.
- Use `{% if %}…{% elseif %}…{% endif %}` and `{% set %}` to compute derived values.
- Use `| length` for counts and `and`/`or` for boolean composition in conditions.
- Avoid complex inline logic in attributes; pre-compute CSS classes with `{% set %}`.
- Fail closed: wrap optional fragments with `{% if value %}…{% endif %}`.

## Implementation Plan (Phases)
1) Add shared Portable Text schema
- Add `bootstrap/cms/schemaTypes/objects/portableText.ts` defining `block` styles (normal, h2–h4), lists (bullet, numbered), marks (strong, em, code), and link annotation (url, open in new tab).

2) Add new Sanity objects (blocks)
- Files: `bootstrap/cms/schemaTypes/objects/{heroCover,featuresGrid,cardsGrid,pricingTable,faqAccordion,ctaBanner}.ts` using `portableText` for copy fields.
- Update `bootstrap/cms/schemaTypes/index.ts` and `landingPage.ts` to include these in `blocks[]`.
- Migrate existing `twoColumnText` to `portableText` fields (`left`, `right`) while retaining compatibility with legacy `text` fields.

3) Add Portable Text rendering helper
- Add a small Node helper (e.g., `bootstrap/web/src/_data/portableText.js`) that uses `@portabletext/to-html` and a link serializer to add `rel` to external links. Register a Nunjucks filter `pt` in Eleventy config or import helper inside templates.

4) Add Nunjucks block templates
- Files: `bootstrap/web/src/_includes/blocks/{heroCover.njk,featuresGrid.njk,cardsGrid.njk,pricingTable.njk,faqAccordion.njk,ctaBanner.njk}`.
- Use `| pt | safe` to render PT fields. For `twoColumnText`, support both legacy HTML and PT during transition.

5) Extend GROQ mapping (images only)
- Update `bootstrap/web/src/_data/pages.js` to expand image URLs for new blocks: `heroCover.bgImage.url`, `cardsGrid.cards[].image.url`, etc. PT arrays pass through as-is.

6) Authoring QA
- In Sanity Studio, create a test `Landing Page` and add one of each new block.
- Verify previews display intelligible titles (via `preview` config) and PT editing works (headings, lists, links).

7) Rendering QA
- Run `serve.sh` for local dev; ensure layout, spacing, and responsiveness match Bootstrap examples.
- Validate PT output (headings map to correct tags, lists render correctly, external links have `rel` attributes).

8) Sync & Update tooling
- Keep `update.sh` simple and resilient: copy entire `web/src/_includes/` and `web/src/_data/`, plus `.eleventy.js` and `listen.js`, instead of piecemeal edits.
- Ensure `.eleventy.js` registers the `pt` filter; the baseline file shipped in `bootstrap/web/.eleventy.js` remains source of truth.
- Keep listener (`web/listen.js`) synced to reliably trigger rebuilds (touches `src/_data/pages.js`).

9) Polish & Docs
- Minimal CSS tweaks in `site.css` if necessary (e.g., spacing for banners, PT content margins).
- Update `README.md` with a “Rich Text” section: how PT is used, authoring tips, and supported marks/styles.

## Validation & QA Checklist
- Templates compile with Nunjucks-only constructs (no ternaries or `.length` in expressions).
- `update.sh` copies: `cms/schemaTypes`, `web/src/_includes/`, `web/src/_data/`, `web/.eleventy.js`, and `web/listen.js`.
- `web/.eleventy.js` includes `pt` filter and Eleventy runs without “filter not found”.
- `pages.js` GROQ includes new block cases and expands required image URLs consistently (`bgUrl`, `url`).
- Sanity content published (no drafts) when using public client; ENV in `web/.env` matches Studio project/dataset.
- Optional: temporary debug traces in `landing.njk` (HTML comments) to print `_type`, keys, and counts during development.

## Schema Safety Rules (to prevent syntax errors)
- Array/object delimiters: visually balance `of: [{ ... }]` and object field arrays; avoid stray brackets.
- Keep schemas minimal and flat: prefer simple field arrays over deep nesting to reduce bracket complexity.
- Use TypeScript checks locally: run `cd cms && npx tsc --noEmit` to catch syntax/typing errors early.
- Sanity CLI check: run `cd cms && npx sanity check` to validate schema consistency.
- Editor formatting: ensure auto-format on save to surface bracket mismatches.

## Automation (recommended)
- Add a lightweight script to validate before syncing:
  - `cms`: `npx tsc --noEmit && npx sanity check`
  - `web`: `node -e "require('nunjucks')"` and a quick `@11ty/eleventy` dry run locally.
- Optionally integrate these into `update.sh` as preflight checks (non-blocking warnings) to catch issues before copying to target projects.

## Acceptance Criteria
- Editors can add any of the 9 blocks to a landing page in Sanity.
- Rich formatted copy (Portable Text) is supported and rendered for hero leads, feature intros/items, card text, pricing subtitles/features, FAQ answers, two-column text, and CTAs.
- 11ty builds pages where each block renders correctly with sensible defaults.
- Images load via Sanity asset URLs; blocks handle missing optional fields gracefully.
- No JavaScript beyond Bootstrap’s bundle required.

## Risks / Considerations
- Link security: Ensure external links include `rel="noopener noreferrer"` when `target=_blank`.
- Custom marks/components: If future PT needs icons, callouts, or custom embeds, extend serializers accordingly.
- Image crops: If background images require focal points, later integrate Sanity image builder for optimized sizes and hotspot.
- Migration: Existing `twoColumnText` uses raw HTML; maintain fallback rendering until content is migrated.
- i18n: Out of scope for this iteration.

## Estimated Effort (first pass)
- Schema + templates for 6 new blocks: ~4–6 hours.
- GROQ + QA + docs: ~2–3 hours.

---
If this plan looks good, I’ll proceed to implement the schema objects, block templates, and GROQ mappings in the order above.
