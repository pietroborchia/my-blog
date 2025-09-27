
# Jekyll + KaTeX Minimal Starter

A tiny Jekyll site ready for GitHub Pages:
- One base layout (`_layouts/default.html`) with KaTeX included once via `_includes/katex.html`.
- Posts in `_posts/`, pages are simple Markdown files with front matter.
- Uses Jekyll's `relative_url` filter so links work at `https://USERNAME.github.io/REPO-NAME/`.

## Setup
1) Edit `_config.yml`:
   - `url: "https://USERNAME.github.io"`
   - `baseurl: "/REPO-NAME"` (empty for `USERNAME.github.io` root sites).

2) Push to GitHub and enable **Pages**.
   GitHub Pages will build Jekyll automatically.

Docs:
- GitHub Pages + Jekyll: https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll
- Jekyll `relative_url` filter: https://jekyllrb.com/docs/liquid/filters/
- KaTeX auto-render: https://katex.org/docs/autorender.html
