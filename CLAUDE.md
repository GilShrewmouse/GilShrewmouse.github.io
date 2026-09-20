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
_config.yml          site title, description, url, permalink
_data/games.yml      portfolio list (one block per game)
_data/links.yml      About-block link buttons (label + url): Email, LinkedIn, Mastodon, Steam, itch.io, Bluesky
_layouts/default.html  shared frame: top tabs (About / Portfolio anchors on home, Blog page) + footer
_layouts/post.html     blog post layout
_posts/              blog posts, named YYYY-MM-DD-title.md
assets/css/style.css   ALL styling; colors, background and fonts are variables in :root
assets/img/            background.jpg, av_square.jpg, games/ (covers), blog/, icons/ (social SVGs)
assets/favicon/        favicon.ico, PNG icons (16/32/180/192/512), site.webmanifest; linked in _layouts/default.html <head>
index.html           home: intro + About + Portfolio (year tabs, newest first; only one year shown at a time)
_includes/portfolio-group.html   one portfolio panel (a year's heading + tiles)
blog.html            blog list (published at /blog/)
```

## Conventions
- Portfolio data lives only in `_data/games.yml`. Fields: `title`, `role`, `year` (number; usually the release year, but can be the year of a DLC or new edition), `image`, `url`, and optional `credited` and `group`. Adding a game with a new year creates a new year tab automatically (only years that have games get a tab).
- `credited: false` marks a game the user is not credited in; the tile shows "(not credited)" after the role. These games are sorted into normal year tabs.
- `group: "Not released"` is used INSTEAD of `year` for the last tab (genre placeholder title like "Management Game", empty `image` and `url`). Empty `image` gives an empty translucent tile; empty `url` gives a tile that is not a link. Inside a year (and inside "Not released") tiles are sorted A-Z by title (case-insensitive, `sort_natural`), so the position of a block in the file does not matter, only its `year`.
- The user edits `games.yml` by hand (years, roles, titles with ™/®). Treat the file on disk as the truth and never revert those edits.
- Portfolio UI: intro text, then year tabs. Only one year is shown at a time; it opens on the current year (falls back to the newest year if there are no games in it). Tab markup and the small inline script are in `index.html`; one panel per year is in `_includes/portfolio-group.html`. Without JavaScript all years are shown stacked.
- About block: text uses the same muted style as the portfolio intro (`.about-text`); the link buttons come from `_data/links.yml` (gold pill `.button` with an icon + label, external links open in a new tab, `mailto:` does not). Icons are SVG files in `assets/img/icons/` (named in the `icon` field, without `.svg`), used as a CSS mask (`.icon`) painted with `currentColor`, so they follow the site colors. To add a button: drop an SVG in that folder and add a block to `links.yml`. If a drawing looks too high or low next to the others, set `icon_shift` (e.g. `"-0.1em"`) on its block; LinkedIn uses this because its visual weight sits low.
- The avatar is a square with rounded corners (12px, same as the game tiles), not a circle.
- First screen: `index.html` wraps the profile (`.hero`: avatar + name + tagline) and the About block in `.intro`, inside `.first-screen` (full viewport height minus the top menu, content centered vertically). Wide screens (1000px and up): two columns, About on the left and the profile as a card on the right (same height, panel look, 180px avatar). Narrower screens: the profile is a compact row (avatar beside the text; stacked under 600px) above About. The top menu has a fixed height (`--topbar-h`) that the centering relies on.
- Blog posts: the front matter (`---` ... `---`) must start on the very first line of the file; any stray text above it (e.g. a pasted "markdown" label) breaks the title and layout. Post URLs look like `/blog/2026/09/hello-world/` (no day). Post images go in `assets/img/blog/` and must be committed/pushed, otherwise they 404 on the live site. `.panel p > img` in `style.css` keeps them inside the block (max 80vh tall).
- The portfolio is a section on the home page (`#portfolio`), not a separate page. The top-menu Portfolio link is `/#portfolio`.
- `permalink` in `_config.yml` also changes where pages are published (`blog.html` is served at `/blog/`, not `/blog.html`). Link to `/blog/`, never `/blog.html`; a wrong link gives a 404.
- In YAML, quote any value containing `:` or `#` (e.g. `title: "Zero Parades: For Dead Spies"`). Indent with spaces, never tabs.
- Image paths are absolute from the site root, e.g. `/assets/img/games/name.jpg`. Filenames are case-sensitive on GitHub.
- Keep the site dark. Change look through the `:root` variables in `style.css` before adding new rules. Palette follows the background photo: warm dark browns plus brass gold accent `--accent` (#d6b05a); no purple.
- Game name and job on a tile appear on hover (and on keyboard focus); on touch screens and on tiles without a cover they are always visible.
- Keep pages self-contained and simple; avoid heavy images (background under ~500 KB, game covers are 460x215 px).
- Layout: page width is `--page-width` (1520px) so 3 tiles of 460px fit in one row; the grid drops to 2 columns under 820px and 1 under 520px.
- The repo is public: never commit secrets or private notes.

## Workflow
- Preview locally: `bundle exec jekyll serve`, then open http://localhost:4000 . Restart it after editing `_config.yml`. Ruby 3.3 is in `C:\Ruby33-x64\bin`, which may not be on PATH in every shell.
- Do not commit or push unless the user says so. When asked: commit to `main`, then push, then tell the user to check the Actions tab for a green tick.
- Commit format: the summary (first line) is ONLY a version number, written `vX.Y.Z` (no dot after the v), e.g. `v0.0.3`. The description (body) is a short bullet list (`- ...`) of the actual changes. Keep the `Co-Authored-By` trailer at the end. History so far: v.0.0.1, v0.0.2, then the redesign (PR #1), which the user counts as v0.1.0. Then v0.1.1 (favicon). Raise the last number by one for each commit (v0.1.2, v0.1.3, ...) until the user says to make a bigger version jump.
- Pushing needs a GitHub login: Git Credential Manager opens a sign-in window on the user's screen the first time; the user completes it once and it is remembered. Do not interrupt while it is open.
- Never commit `_site/`, `.jekyll-cache/` or `Gemfile.lock` (covered by `.gitignore`).
- Never force-push, and never delete files without asking first.
- If a GitHub Actions build fails, read the error: it is usually a YAML or front-matter (`---`) typo.

## Still to do
- Replace the placeholder texts in `index.html` (heading, tagline, About).
- Add more games to `_data/games.yml`; compress `background.jpg`.
