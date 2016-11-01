---
title: Hexo Useful Tips
date: 2015-01-17T09:48:02
tags:
 - hexo
categories:
 - blogging
---

[Hexo] is static site generator framework suitable for blogging. It it written javascript and uses Node.js and it is pretty fast. After playing with Octopress and Jekyll, I finally switched to Hexo.
The documentation is not bad, bot some aspects are bot covered, so it needs to google to figure-out some aspects. The good thing that there is a large developer and user community (many of them are from China) and there are a lot of sources and examples.

Anyway, I think some tips will be useful for Hexo newcomers.

## Tags and Categories Localization/Customization

In WordPress you can customize tags and categories. Particularly, you can specify a localized name and a SEO-friendly slug for each one. In Hexo it is not so straightforward, but still possible.

By default, when you tag and categorize your post, you should use english names for your tags (and categories) to produce nice SEO-friendly URLs. e.g. _2015-01-17-my-awesome-post.md_:

```markdown 
title: "My Awesome Post"
date: 2015-01-17 09:04:02
tags:
  - tag1
  - по-русски
categories:
  - my category
---
Hello world!
```

If you want your tags and categories on your language and the URLs still look nice in ASCII, you may use [`tag_map` and `category_map`](http://hexo.io/docs/configuration.html#Category_&_Tag) parameters in _config.yml_ file of your blog:

~~~ yml
tag_map:
  tag1: supertag
  по-русски: in-russian
  fun: fun and jokes
  jokes: fun and jokes

category_map:
  my category: the other category
  разное: other
~~~

Now tags and categories paths will be more obvious. Spaces and underscores in urls are replaced with dashes (-), but I prefer setting it explicitly.

You can even set one URL prefix for two different tags (_config.yml_):

~~~ yml
tag_map:
  fun: fun and jokes
  jokes: fun and jokes
~~~

**What I am missing:** Extracting `tag_map` and `category_map` to separate files.

## Other Notes

`relative_link: true` in config breaks the pagination in Hexo 3.1.1, use `false` instead:

~~~yml
relative_link: false
~~~

[hexo]: http://hexo.io/
