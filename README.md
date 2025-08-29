# Sanity + 11ty + Bootstrap

Make pages in Sanity. See them in 11ty. Ship fast.

## Requirements

- Node.js + npm
- Sanity CLI: `npm i -g @sanity/cli`
- PM2: `npm i -g pm2`

## Setup (one time)

1) Create a Sanity project (get your project ID).
2) In this repo, make a `.env`:
```
PROJECT_NAME="my-site"
SANITY_PROJECT_ID="your-sanity-project-id"
SANITY_DATASET="production"
```
3) Make scripts executable: `chmod +x generate.sh serve.sh stop.sh update.sh`
4) Log in: `sanity login`

## Usage

### Make a project
```
mkdir my-site && cd my-site
../sanity-11ty-bootstrap/generate.sh .
```

### Run it
```
../sanity-11ty-bootstrap/serve.sh .
```
- Site → http://localhost:8080
- Studio → http://localhost:3333

First run tip: In Studio, create and publish “Site Settings” to power the global header/footer.

### 3. Stop the Development Servers

To stop all running development servers, use the `stop.sh` script from your project's directory:

```bash
../sanity-11ty-bootstrap/stop.sh .
```

This will stop the `pm2` processes for the 11ty site, Sanity Studio, and the content listener.

### Update later
From inside your project:
```
../sanity-11ty-bootstrap/update.sh .
```
Pick one:
- 1) New templates/pages only (add missing)
- 2) Templates/pages (add + overwrite)
- 3) Scripts (`_data`, `.eleventy.js`, `listen.js`, `serve.sh`, `stop.sh`, `update.sh`)
- 4) Update everything

### Demo

[![Watch the demo](screenshot.png)](https://raw.githubusercontent.com/Miki-AG/sanity-11ty-bootstrap/main/demo.mp4)

## Technical Notes

- Portable Text: The site renders Sanity Portable Text via a Nunjucks filter `pt` registered in `web/.eleventy.js`. The helper lives in `web/src/_data/portableText.js`.
- Global header/footer: Fetched via `web/src/_data/globals.js` and injected by the base layout. Per‑page header blocks are not needed.
- Bootstrap Icons: Enabled via CDN in the base layout; use `<i class="bi bi-star-fill"></i>` or set `bi` field on featuresGrid items.
- CSS defaults: `web/src/assets/site.css` removes body margin, keeps header/footer full‑bleed, and provides light helpers for hero, features and cards.
- Live updates: `web/listen.js` listens for `landingPage` and `siteSettings` changes and touches data files to trigger 11ty rebuilds (used by `serve.sh`).
