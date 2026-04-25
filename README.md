Docs:
- GitHub Pages + Jekyll: https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll
- Jekyll `relative_url` filter: https://jekyllrb.com/docs/liquid/filters/
- KaTeX auto-render: https://katex.org/docs/autorender.html

Local preview:
1. Install Ruby and Bundler if they are not already installed.
2. Install the blog dependencies:
   ```powershell
   bundle install
   ```
3. Start the local Jekyll server:
   ```powershell
   .\serve.bat
   ```
4. Open `http://127.0.0.1:4000/my-blog/`.

The repository structure is the following: <br>
repo/ <br>
|-- Gemfile <br>
|-- serve.bat              <-- local preview helper <br>
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
