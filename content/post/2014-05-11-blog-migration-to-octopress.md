---
title: "Blog Migration to Octopress"
date: 2014-05-11 09:58:54 +0300
comments: true
categories:
 - blogging
---
I have recently migrated my blog from Blogger and Tumblr to Octopress.
Process was fairy simple. I found two scripts to convert my old posts to Markdown files for Octopress.
<!--more-->
## Importing Blogger Blog Posts to Octopress

Firstly, I exported blog archive from Blogger to XML archive (_Blogger->Settings->Other->Export Blog_)

Then I found a [script][blogger-import] to convert blogger XML file to Octopress posts fileset. I had to install _nokogiri_ gem first.

    gem install nokogiri
    ruby import.rb my-blog.xml

Script created _\_posts_ and _\_drafts_ folders with HTML post files. Anyway, it worth reviewing posts and correcting a markup, if necessary.

## Importing Tumblr Blog Posts to Octopress

There is a [ruby script for Jekyll][tumblr-import] for importing Tumblr blogs.

    $ gem install jekyll-import
    $ ruby -rubygems -e 'require "jekyll-import";
        JekyllImport::Importers::Tumblr.run({
          "url"            => "http://myblog.tumblr.com",
          "format"         => "md", # "html" or "md"
          "grab_images"    => false,  # whether to download images as well.
          "add_highlights" => false,  # whether to wrap code blocks (indented 4 spaces) in a Liquid "highlight" tag
          "rewrite_urls"   => false   # whether to write pages that redirect from the old Tumblr paths to the new Jekyll paths
        })'

Script created _\_posts/tumblr_ with folders with Markdown files.

The only thing left is to review imported posts and include them to new blog.
That's it.

## Links
  [Creating a Github Blog Using Octopress by Tom Ordonez](http://www.tomordonez.com/blog/2012/06/04/creating-a-github-blog-using-octopress/)

  [blogger-import]: https://gist.github.com/juniorz/1564581 "Import a blogger archive to jekyll (octopress version)"
  [tumblr-import]: http://import.jekyllrb.com/docs/tumblr/ "Jekyll importer for Tumblr"
