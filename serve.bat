@echo off
setlocal

where bundle >nul 2>nul
if errorlevel 1 (
  echo Bundler was not found. Install Ruby, then run:
  echo gem install bundler
  echo bundle install
  exit /b 1
)

bundle exec jekyll serve --livereload --host 127.0.0.1
