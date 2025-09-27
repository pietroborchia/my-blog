Docs:
- GitHub Pages + Jekyll: https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll
- Jekyll `relative_url` filter: https://jekyllrb.com/docs/liquid/filters/
- KaTeX auto-render: https://katex.org/docs/autorender.html

The repository structure is the following: <br>
repo/ <br>
├─ _config.yml <br>
├─ _layouts/ <br>
│  └─ default.html        <-- base template (KaTeX here once) <br>
├─ _includes/ <br>
│  └─ katex.html          <-- optional: keep KaTeX block separate <br>
├─ _posts/ <br>
│  └─ 2025-09-27-hello.md <-- a sample post (uses the layout) <br>
├─ assets/ <br>
│  └─ style.css <br>
└─ index.md               <-- homepage <br>
