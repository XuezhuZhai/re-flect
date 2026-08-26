# Deploying re•flect to `re-flect.github.io`

Goal: publish this static site for free at **https://re-flect.github.io/**

## What that URL requires
GitHub builds the URL as `<account>.github.io`. To get `re-flect.github.io`, the part
**before** `.github.io` must be a GitHub **account or organization named `re-flect`**,
containing a repository named **`re-flect.github.io`**.

- If your personal username is already `re-flect` → just create the repo `re-flect.github.io`.
- If not → create a **free GitHub Organization** named `re-flect`
  (github.com → **+** → *New organization* → Free), then create the repo under it.

> `re-flect` is a valid name (hyphens are allowed, just not at the start/end).
> If the name is taken, you'd need a different one — e.g. repo `re-flect` under your
> existing user gives `https://<username>.github.io/re-flect/` instead (still fine).

## Steps
1. Create the repo **`re-flect.github.io`** under the `re-flect` account/org
   (Public; no README needed).
2. Push the contents of this folder to its `main` branch:
   ```bash
   cd "C:/Users/xuzhai/source/repos/reflectWebsite"
   git init
   git add .
   git commit -m "Publish re-flect site"
   git branch -M main
   git remote add origin https://github.com/re-flect/re-flect.github.io.git
   git push -u origin main
   ```
3. Repo → **Settings → Pages** → Source = *Deploy from a branch*, Branch = `main` / `/ (root)` → **Save**.
4. Wait ~1–2 min. Site is live at **https://re-flect.github.io/** (HTTPS is automatic).

## Notes
- `.nojekyll` is already in the repo — it tells GitHub Pages to serve files as-is
  (no Jekyll processing). Keep it.
- All links/assets are **relative**, so the site also works fine if served from a
  sub-path like `https://<username>.github.io/re-flect/`.
- Large source files are gitignored via `.gitignore` (`*.mov`). The site uses the
  compressed `.mp4` / `.jpg` versions.

## Attaching re-flect.org later (optional)
When you transfer the domain out of Squarespace and want to use it:
1. Add a file named `CNAME` at the repo root containing one line: `re-flect.org`
2. At your DNS provider, add:
   - `A` records for the apex `re-flect.org` → GitHub Pages IPs:
     `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
   - `CNAME` for `www` → `re-flect.github.io`
3. Repo → Settings → Pages → Custom domain = `re-flect.org` → Save → tick **Enforce HTTPS**.

The github.io URL keeps working; the custom domain just points at the same site.
