# The Corner in the Middle personal blog

This repository contains a [Jekyll](https://jekyllrb.com/) blog to be served on [Github Pages](https://pages.github.com/).
It can also be generated  and served outside github by generating the website with jekyll (usually by 
running `jekyll build`) and copying it into a static website host (like _Github Pages_ or _Amazon S3_)

## jekyll

From [Jekyll docs](https://jekyllrb.com/docs/):
> [Jekyll](https://jekyllrb.com/) is a static site generator. You give it text written in your favorite markup language, 
> and it uses layouts to create a static website. 
> You can tweak how you want the site URLs to look, what data gets displayed on the site, and more.

**Important Note:** Any tweaks to `_config.yml` needs a jekyll restart since it jekyll does not reload when this file
changes (basically because input and output are defined on that file)

### Dockerfile

A `jekyll` Dockerfile is included by convenience. It's just using the default [Jekyll Docker container](https://github.com/envygeeks/jekyll-docker).
It needs a jekyll website on the volume `/srv/jekyll` and it exposes 4000 port for local testing.

The `ENTRYPOINT` is a script that runs `CMD` as Jekyll user on the right directories and permissions.
The default `CMD` is `jekyll help`. 

To use it, just run:

Bash:
```bash
docker build -t jekyll-dev . && docker run --rm -p 4000:4000 -v $(pwd):/srv/jekyll jekyll-dev jekyll serve
```

PowerShell:
```powershell
docker build -t jekyll-dev . && docker run --rm -p 4000:4000 -v ${PWD}:/srv/jekyll jekyll-dev jekyll serve
```

Then navigate to `localhost:4000` and you should be able to see the static website.

## Themes

Jekyll's themes can be used to customize the look and feel of a Jekyll site. Github Pages supports some [bundled themes](https://pages.github.com/themes/)
as well as [external themes](https://github.blog/2017-11-29-use-any-theme-with-github-pages/).

[The Corner in the Middle](https://www.cornerinthemiddle.com) uses [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes) 
theme with very few customizations.

Minimal Mistakes documentation and examples can be found [here](https://mmistakes.github.io/minimal-mistakes/)

## Plugins

Several plugins have been applied to jekyll, most of them to have extra [liquid](https://github.com/Shopify/liquid) tags
available, like `{% gist <gist_id> %}`, `<% figure %>` and others. Refer to [Jekyll](https://jekyllrb.com/docs/liquid/) 
or [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/docs/helpers/) documentation for additional 
information.

## Kramdown

Minimal Mistakes ships with some utility classes to help format posts and pages.
Refer to [Utility Classes](https://mmistakes.github.io/minimal-mistakes/docs/utility-classes/) for additional 
information.

## Front Matter

> The front matter is a section in the beginning of a book. 
> The front matter in a book consists of: the title page (which includes copyright information, the ISBN, etc.), 
> the dedication, the epigraph, table of contents, acknowledgements, the foreword, the preface, the introduction, 
> and the prologue.

Jekyll uses front matter yaml blocks to customize or add content to pages and posts, among others:

```markdown
---
title: How to add front matter to a page
date: 2001-12-01
excerpt: >-
   This is a multiline value
   that spawns several lines
   until a new attribute is found
categories:
  - How To
custom:
    var: custom var
---

{{ custom.var }} 
```

As seen above, Jekyll exposes front matter variables as liquid variables to use them in the content.

## Blog Content

Blog contains posts and pages. Jekyll and Minimal Mistakes provide default pages for Posts, with a home page showing the
last 5 post-entries, and a landing page for Posts (by year / month), Categories and Tags.

Pages need to be added manually to navigation / links / home.

Jekyll indexes pages and posts and both appear on `Search` results.

### Posts

See [Jekyll Posts](https://jekyllrb.com/docs/posts/) and [Minimal Mistakes Posts](https://mmistakes.github.io/minimal-mistakes/docs/posts/)


### Pages

See [Jekyll Pages](https://jekyllrb.com/docs/pages/) and [Minimal Mistakes Pages](https://mmistakes.github.io/minimal-mistakes/docs/pages/)

#### Shortcuts
Some [front matter](https://jekyllrb.com/docs/front-matter/) shortcuts:

|variable|usage|example|
|---|---------|---|
| `classes` | additional style classes fo the layout | `classes: wide` makes the post to use entire page wide |
| `toc` | include table of content |`toc: true` adds a toc to right side (or top of post/page if `classes: wide` are used)|
|   |   | `toc_sticky: true` keeps the toc floating on right|
| `categories` | add post / page to one or more categories | |
| `tags` | add post / page to one or more tags | |
| `excerpt:` | adds an excerpt to be displayed on RSS / collections / seo | `excerpt: >- ...` (multiline excerpt)  |
| `layout:` | defines the layout for the page / post | `layout: post` |

See [Jekyll Front Matter](https://jekyllrb.com/docs/front-matter/) and [Minimal Mistakes Defaults](https://mmistakes.github.io/minimal-mistakes/docs/configuration/#front-matter-defaults).

##### Layouts

See [Minimal Mistakes Layouts](https://mmistakes.github.io/minimal-mistakes/docs/layouts/)

### Navigation Bar

Edit `_data/navigation.yml` as instructed on [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/docs/navigation/)

### Icons and Favicon

Favicon was generated with [real favicon generator](https://realfavicongenerator.net/).

Header (`_includes/head/custom.html`) contains favicon based on the above generator output. 

### Social Media links

Social media links are added on the footer and author via `_config.yml`

## Comments and reactions

Post comments are provided by [Disqus](https://disqus.com/) using default Minimal Mistakes integration (see `_config.yml`).

# Medium and dev.to integrations

Medium and dev.to integrations are planned via [GitHib Actions](https://github.com/features/actions)
