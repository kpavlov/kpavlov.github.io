---
title: "Slate: Static API Documentation Generator"
tags:
  - documentation
date: 2015-04-12T22:00:26
---

I came across [slate][slate] tool when I was looking for API documentation generator for our webservice API.
![slate screenshot](/assets/2015/04/slate-site.png)

I am the big fan of [Markdown][markdown] and I was looking for a tool like this for writing a documentation.
<!--more-->

## Getting Started with Slate
Slate requires Ruby 1.9.3 and newer. 

It's really easy to get started:

1. Install Ruby 1.9.3 or newer
2. Install Bundler (you may need root permissions)

        gem install bundler

3. Fork a `https://github.com/tripit/slate.git` repository in GitHub
4. Clone your forked repository locally:

        git clone https://github.com/YOURUSERNAME/slate.git
        cd slate

5. Install bundle dependencies

        bundle install

If installing dependencies fails you may download [stable version](https://github.com/tripit/slate/releases/tag/v1.0) of slate, extract from archive and try to install dependencies again.
7. Start the test server

        bundle exec middleman server

8. Navigate to http://localhost:5739 to see your documentation
9. Run `rake build` to generate documentation locally or `rake publish` for deploying to remote server (you may need an [extra setup](https://github.com/tripit/slate/wiki/Deploying-Slate)).

See the [slate wiki](https://github.com/tripit/slate/wiki) for more details.

Predefined (sample) API documentation is defined in the `sources/index.md` document.
You may want to create a new one in `source/v1/index.md`. It will be transferred to http://localhost:5739/v1/

## Generating PDF version

Along with HTML documentation, having a PDF version is also desirable.
There is no PDF documentation generator in Slate out of the box. But it is very easy to integrate a ruby PDF generator 

Add and activate pdfmaker ruby gem in _config.rb_:

``` ruby
## Pdfmaker custom extension. Add if you want PDF generati
require 'makepdf'

activate :pdfmaker
```

Then create file _makepdf.rb_ in the base folder:

```ruby 
module PdfMaker
  class << self
    def registered(app)
      app.after_build do |builder|
        begin
          require 'pdfkit'

          kit = PDFKit.new(File.new('build/pdf.html'),
                           :page_size => 'A4',
                           :margin_top => 10,
                           :margin_bottom => 10,
                           :margin_left => 10,
                           :margin_right => 10,
                           :disable_smart_shrinking => false,
                           :print_media_type => true,
                           :dpi => 96
          )

          file = kit.to_file('build/api.pdf')

        rescue Exception =>e
          builder.say_status "PDF Maker",  "Error: #{e.message}", Thor::Shell::Color::RED
          raise
        end
        builder.say_status "PDF Maker",  "PDF file available at build/api.pdf"
      end


    end
    alias :included :registered
  end
end

::Middleman::Extensions.register(:pdfmaker, PdfMaker)
```

As you can see, [PDFKit](https://github.com/pdfkit/pdfkit) and subsequently [wkhtmltopdf](http://github.com/antialize/wkhtmltopdf) is used under the hood.


Clone _source/layouts/layout.erb_ and modify it to be pdf-friendly:

```html 
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="date" content="<%= Time.now.strftime("%Y-%m-%dT%H:%M:%S%Z") %>">
    <title><%= current_page.data.title %> v.<%= current_page.data.version %></title>
    <meta name="pdfkit-footer_right" content="Page [page] of [topage]">
    <meta name="pdfkit-footer_left" content="[title] | <%= Time.new.strftime("%Y-%m-%d") %>">
    <meta name="pdfkit-footer_line" content="">
    <meta name="pdfkit-footer_font_size" content="8">
    <%= stylesheet_link_tag :print, media: :all %>

</head>

<body class="<%= page_classes %>">

<section class="titlePage">
    <% if current_page.data.home_url %>
        <a href="<%= current_page.data.home_url %>"><%= image_tag "logo.png" %></a>
    <% else %>
        <%= image_tag "logo.png" %>
    <% end %>

    <h1><%= current_page.data.title %></h1>

    <footer>
        <div>Version  <%= current_page.data.version %></div>
        <div>Date: <%= Time.new.strftime("%Y-%m-%d") %></div>
    </footer>
</section>
<section class="content">
    <%= yield %>
    <% current_page.data.includes && current_page.data.includes.each do |include| %>
        <%= partial "includes/#{include}" %>
    <% end %>
</section>
</body>
</html>
``` 
Notice `pdfkit-footer_*` meta tags here.

Create a separate index file with print layout _source/pdf.md_:

~~~markdown
---
layout: "pdf"
title: API Reference
version: "2.32"
---
Blah-blah-blah...
Rumors volare in berolinum!
Squid combines greatly with salted ghee.
Loren ipsum...
~~~

Important thing is to specify layout "pdf"

Now you may run generation:

    bundle exec middleman build --clean

I hope this little instruction will help you to generate a PDF version of your API.

## Other API docs generators. 

Other static API documentation generators:

- [Aglio](https://github.com/danielgtaylor/aglio). It renders API documentation in [API Bluepring](http://apiblueprint.org/) format to Beautiful sites.

- [Swagger UI][swagger-ui]. It allows to generate REST API documentation from Java sources. See the [article](http://pilhuhn.blogspot.de/2012/10/restjax-rs-documentation-generation.html), [API documentation example](https://access.redhat.com/documentation/en-US/JBoss_Operations_Network/3.1/html-single/Rest_API/index.html).

[slate]: https://github.com/tripit/slate
[swagger-ui]: https://github.com/swagger-api/swagger-ui
[markdown]: https://daringfireball.net/projects/markdown/

http://jsondoc.org/ - Java java library useful to build the documentation of your RESTful services. Can be used to generate a static site.
