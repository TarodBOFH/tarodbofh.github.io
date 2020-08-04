ARG JEKYLL_VERSION=4.1.0
FROM jekyll/jekyll:$JEKYLL_VERSION

CMD ["jekyll", "serve", "--drafts"]
