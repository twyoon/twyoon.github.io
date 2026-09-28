# Taewoong Yoon's Personal Website

This is my personal website built using [Jekyll](https://jekyllrb.com/) with the **Minima** theme.

## Local development

1. Run `bundle install`
1. Run `bundle exec jekyll serve`

## CV PDF generation

Run `./generate_cv.sh` to rebuild [assets/CV_Taewoong_Yoon.pdf](assets/CV_Taewoong_Yoon.pdf) from [cv.md](cv.md) and [publications.md](publications.md). Requires Python 3, Pandoc, and a TeX installation with `pdflatex` and the packages used in [_cv_header.tex](_cv_header.tex).

Edit content in the Markdown pages; [script/cv-layout.lua](script/cv-layout.lua) handles PDF-only date alignment, compact teaching entries, and reference columns. Typography and contact links are configured in [_cv_header.tex](_cv_header.tex) and [_cv_name.tex](_cv_name.tex).
