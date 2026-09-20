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
_layouts/default.html  shared frame: top tabs (About / Portfolio / Blog) + footer
_layouts/post.html     blog post layout
_posts/              blog posts, named YYYY-MM-DD-title.md
assets/css/style.css   ALL styling; colors, background and fonts are variables in :root
assets/img/            background.jpg, av_square.jpg, games/ (covers), blog/
index.html           home: intro + About + link to portfolio
games.html           portfolio page with year tabs (filters tiles by year, small inline JS)
blog.html            blog list
```

## Conventions
- Portfolio data lives only in `_data/games.yml`. Fields: `title`, `role`, `year` (number), `image`, `url`. Adding a game with a new year creates a new year tab automatically.
- In YAML, quote any value containing `:` or `#` (e.g. `title: "Zero Parades: For Dead Spies"`). Indent with spaces, never tabs.
- Image paths are absolute from the site root, e.g. `/assets/img/games/name.jpg`. Filenames are case-sensitive on GitHub.
- Keep the site dark. Change look through the `:root` variables in `style.css` before adding new rules.
- Keep pages self-contained and simple; avoid heavy images (background under ~500 KB, covers about 800 px wide).
- The repo is public: never commit secrets or private notes.

## Workflow
- Preview locally: `bundle exec jekyll serve`, then open http://localhost:4000 . Restart it after editing `_config.yml`.
- Do not commit or push unless the user says so. When asked: commit to `main` with a short, clear message, then push, then tell the user to check the Actions tab for a green tick.
- Never commit `_site/`, `.jekyll-cache/` or `Gemfile.lock` (covered by `.gitignore`).
- Never force-push, and never delete files without asking first.
- If a GitHub Actions build fails, read the error: it is usually a YAML or front-matter (`---`) typo.

## Still to do
- Replace the placeholder texts in `index.html` (heading, tagline, About).
- Add more games to `_data/games.yml`; compress `background.jpg`.
