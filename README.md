# Personal/Professional Website with Phoenix

Phoenix is fault tolerant and fast, which is perfect for the web. I've decided
to migrate my website to a Phoenix back-end.

My previous solution was to use Node with Express. Quickly, though, I started
to hate the web design process. Keeping assets was awkward and adding new
pages was unnecessarily verbose, even with a minimalistic framework like
Express.

My website needs to do only a couple basic things:

- Give a summary of who I am
- Give a list of things I know or have interest in
- Route perspective employers to my contact info

More specifically, I want...

1. To be able to make blog-like posts with static Markdown files. I've learned
such a significant portion of my skillset from blog posts that it would be
selfish not to try to give back. I think Markdown is the perfect tool to write
these posts.
2. To make an also static list of topics I'm familiar with. I've decided to
serve this from a database (because it seems that Phoenix better supports
filling up a database, and for speed concerns), but I keep a hard copy for
deployment / if I bork the repo.
3. To have interactive pages I can pimp out with JavaScript and external
libraries. I'm very familiar with d3.js, and I love making interactive graphics
with it. Plus, few people come to a website to read. Have some fun with the
graphics.
