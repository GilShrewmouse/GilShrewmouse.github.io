# Project: personal site (GitHub Pages)

Personal site of Ekaterina Podsevalova: game (L)QA / QA. Dark theme, photo background.
Live at https://gilshrewmouse.github.io/ . Repo: GilShrewmouse/GilShrewmouse.github.io (branch `main`).

## About the user
- Only basically familiar with coding. Explain steps in plain language, one step at a time, and say what each command does.
- Runs Windows. Uses GitHub Desktop and VS Code.
- Prefers being told what changed and where, in short, non-technical summaries.

## Stack
- Jekyll on GitHub Pages (built by GitHub on every push to `main`). No JS framework, no build step of our own.
- Local preview needs Ruby 3.3 (NOT 4.0: Liquid 4 breaks on Ruby 3.2+ removals such as `tainted?` in 4.0). Gems come from the `Gemfile` (`github-pages`).
- Do not add Jekyll plugins that GitHub Pages does not support.

## Structure
```
_config.yml          site title, description, url, permalink, show_blog, exclude
.gitattributes       line-ending rules for Git
_data/games.yml      portfolio list (one block per game)
_data/links.yml      About-block link buttons (label, url, icon), shown in file order
_layouts/default.html  shared frame: top tabs (About / Portfolio anchors on home, Blog page) + footer
_layouts/post.html     blog post layout
_posts/              blog posts, named YYYY-MM-DD-title.md
assets/css/style.css   ALL styling; colors, background and fonts are variables in :root
assets/img/            background.jpg, av_square.jpg, games/ (covers), blog/, icons/ (social SVGs)
assets/favicon/        favicon.ico, PNG icons (16/32/180/192/512), site.webmanifest; linked in _layouts/default.html <head>
index.html           home: intro + About + Portfolio (year tabs, newest first; only one year shown at a time)
_includes/portfolio-group.html   one portfolio panel (a year's heading + tiles)
blog.html            blog list (published at /blog/)
tools/make-og-card.ps1   redraws assets/img/og-card.jpg (the link-preview card); not published (excluded)
```

## Conventions
- Portfolio data lives only in `_data/games.yml`. Fields: `title`, `role`, `year` (number; usually the release year, but can be the year of a DLC or new edition), `image`, `url`, and optional `credited` and `group`. Adding a game with a new year creates a new year tab automatically (only years that have games get a tab).
- `credited: false` marks a game the user is not credited in; the tile shows "(not credited)" after the role. These games are sorted into normal year tabs.
- `group: "Not released"` is used INSTEAD of `year` for the last tab (genre placeholder title like "Management Game", empty `image` and `url`). Empty `image` gives an empty translucent tile; empty `url` gives a tile that is not a link. Inside a year (and inside "Not released") tiles are sorted A-Z by title (case-insensitive, `sort_natural`), so the position of a block in the file does not matter, only its `year`.
- The user edits `games.yml` by hand (years, roles, titles with ™/®). Treat the file on disk as the truth and never revert those edits.
- Portfolio UI: intro text, then year tabs. Only one year is shown at a time; it opens on the current year (falls back to the newest year if there are no games in it). Tab markup and the small inline script are in `index.html`; one panel per year is in `_includes/portfolio-group.html`. Without JavaScript all years are shown stacked.
- About block: text uses the same muted style as the portfolio intro (`.about-text`); the link buttons come from `_data/links.yml` (gold pill `.button` with an icon + label, external links open in a new tab, `mailto:` does not). Icons are SVG files in `assets/img/icons/` (named in the `icon` field, without `.svg`), used as a CSS mask (`.icon`) painted with `currentColor`, so they follow the site colors. Order (chosen by the user): LinkedIn, Email, Mastodon, Bluesky, itch.io, Steam (professional, then community, then projects/gaming). `primary: true` (Email) makes a filled gold button (`.button.primary`), the main way to get in touch. To add a button: drop an SVG in that folder and add a block to `links.yml`. If a drawing looks too high or low next to the others, set `icon_shift` (e.g. `"-0.1em"`) on its block; LinkedIn uses this because its visual weight sits low.
- The avatar is a square with rounded corners (12px, same as the game tiles), not a circle.
- First screen: `index.html` wraps the profile (`.hero`: avatar + name + tagline) and the About block in `.intro`, inside `.first-screen` (starts 32px below the top menu and is NOT stretched to the screen height, so the Portfolio peeks in on load and there is no big empty space). Wide screens (1000px and up): two columns, About on the left and the profile as a card on the right (same height, panel look, 180px avatar). Narrower screens: the profile is a compact row (avatar beside the text; stacked under 600px) above About. The About text is larger (1.1rem, 860px wide) on wide screens only.
- Blog posts: the front matter (`---` ... `---`) must start on the very first line of the file; any stray text above it (e.g. a pasted "markdown" label) breaks the title and layout. Post URLs look like `/blog/2026/09/hello-world/` (no day). Post images go in `assets/img/blog/` and must be committed/pushed, otherwise they 404 on the live site. `.panel p > img` in `style.css` keeps them inside the block (max 80vh tall).
- The portfolio is a section on the home page (`#portfolio`), not a separate page. The top-menu Portfolio link is `/#portfolio`.
- `permalink` in `_config.yml` also changes where pages are published (`blog.html` is served at `/blog/`, not `/blog.html`). Link to `/blog/`, never `/blog.html`; a wrong link gives a 404.
- In YAML, quote any value containing `:` or `#` (e.g. `title: "Zero Parades: For Dead Spies"`). Indent with spaces, never tabs.
- Image paths are absolute from the site root, e.g. `/assets/img/games/name.jpg`. Filenames are case-sensitive on GitHub. Name files with letters and digits only (CamelCase like `TotalWarThreeKingdoms.jpg`): no spaces, `&` or non-Latin letters.
- Sharing / search: `_layouts/default.html` builds `<title>`, meta description, canonical URL and Open Graph / Twitter tags. The home page's title and description are in the front matter of `index.html`; blog posts use the start of the post; other pages fall back to `site.description`. The preview picture is `assets/img/og-card.jpg` (1200x630, avatar + tagline + four covers); regenerate it with `tools/make-og-card.ps1` when the tagline or chosen covers change. Platforms cache previews, so a changed card can take a while to show up when re-shared.
- Keep the site dark. Change look through the `:root` variables in `style.css` before adding new rules. Palette follows the background photo: warm dark browns plus brass gold accent `--accent` (#d6b05a); no purple.
- Game name and job on a tile appear on hover (and on keyboard focus); on touch screens and on tiles without a cover they are always visible.
- Keep pages self-contained and simple; avoid heavy images (background is 1920x1080, about 220 KB; avatar 360x360, about 45 KB; game covers are 460x215 px).
- PRIVACY: phone photos contain GPS location in their metadata (EXIF). Before adding any photo, resize/re-save it so the metadata is dropped (the background and avatar had GPS tags and were cleaned in v0.1.2), and re-check with a scan for an EXIF block. Old versions stay in git history; never rewrite history or force-push without the user's explicit OK.
- Layout: page width is `--page-width` (1496px) = 3 tiles of 460px + 2 tile gaps (14px) + panel padding (2 x 24px) + page padding (2 x 20px). Change these together or the tiles stop being exactly 460px wide. The grid drops to 2 columns under 820px and 1 under 520px.
- `_config.yml`: `exclude:` keeps CLAUDE.md, README.md and `tools/` off the website; `show_blog: false` hides the Blog link in the menu until there is a real post (set it to `true`; the page /blog/ always exists). The `description` there is the user's own wording ("(L)QA" is a deliberate personal gimmick, not a typo) and is not to be changed.
- `.gitattributes` normalizes line endings (no more LF/CRLF warnings) and marks images as binary.
- Accessibility: year buttons use `aria-pressed`; keyboard focus has a visible outline; `prefers-reduced-motion` turns animations off; the avatar has an alt text.
- The repo is public: never commit secrets or private notes.

## Workflow
- Preview locally: `bundle exec jekyll serve`, then open http://localhost:4000 . Restart it after editing `_config.yml`. Ruby 3.3 is in `C:\Ruby33-x64\bin`, which may not be on PATH in every shell.
- Do not commit or push unless the user says so. When asked: commit to `main`, then push, then tell the user to check the Actions tab for a green tick.
- Commit format: the summary (first line) is ONLY a version number, written `vX.Y.Z` (no dot after the v), e.g. `v0.0.3`. The description (body) is a short bullet list (`- ...`) of the actual changes. Keep the `Co-Authored-By` trailer at the end. History so far: v.0.0.1, v0.0.2, then the redesign (PR #1), which the user counts as v0.1.0. Then v0.1.1 (favicon), v0.1.2 (image cleanup, spacing, link previews). Raise the last number by one for each commit (v0.1.2, v0.1.3, ...) until the user says to make a bigger version jump.
- Pushing needs a GitHub login: Git Credential Manager opens a sign-in window on the user's screen the first time; the user completes it once and it is remembered. Do not interrupt while it is open.
- Never commit `_site/`, `.jekyll-cache/` or `Gemfile.lock` (covered by `.gitignore`).
- Never force-push, and never delete files without asking first.
- If a GitHub Actions build fails, read the error: it is usually a YAML or front-matter (`---`) typo.

## Still to do
- Replace the placeholder texts in `index.html` (heading, tagline, About).
- Add more games to `_data/games.yml`; compress `background.jpg`.
