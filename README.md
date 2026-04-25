Docs:
- GitHub Pages + Jekyll: https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll
- Jekyll `relative_url` filter: https://jekyllrb.com/docs/liquid/filters/
- KaTeX auto-render: https://katex.org/docs/autorender.html

The repository structure is the following: <br>
repo/ <br>
|-- _config.yml <br>
|-- _layouts/ <br>
|   `-- default.html        <-- base template <br>
|-- _includes/ <br>
|   |-- katex.html          <-- loaded by pages with `math: true` <br>
|   `-- plotly.html         <-- loaded by pages with `plotly: true` <br>
|-- _posts/ <br>
|   `-- 2025-09-27-(...).md <-- first post <br>
|-- assets/ <br>
|   `-- style.css <br>
|-- data/ <br>
|   `-- (...)               <-- data for posts <br>
|-- about/ <br>
|   `-- index.md            <-- about page <br>
|-- posts/ <br>
|   `-- index.md            <-- posts archive <br>
`-- index.md                <-- homepage <br>
