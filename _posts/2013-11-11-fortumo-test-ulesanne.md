---
layout: post
title: Fortumo test-ülesanne
description: "Käisin Fortumos koodi kirjutamas."
modified: 2013-11-11
category: articles
tags: []
image:
  feature: texture-feature-05.jpg
  credit: Texture Lovers
  creditlink: http://texturelovers.com
---


Vot sihuke lugu siis...

Lorem ipsum dolor sit amet, test link adipiscing elit. **This is
strong.** Nullam dignissim convallis est. Quisque aliquam.

![Smithsonian Image]({{ site.url }}/images/sample-image.jpg)
{: .image-pull-right}

This is emphasized. Donec faucibus. Nunc iaculis suscipit dui. 53 =
125. Water is H2O. Nam sit amet sem. Aliquam libero nisi, imperdiet
at, tincidunt nec, gravida vehicula, nisl. The New York Times (That’s
a citation). Underline.Maecenas ornare tortor. Donec sed tellus eget
sapien fringilla nonummy. Mauris a ante. Suspendisse quam sem,
consequat at, commodo vitae, feugiat in, nunc. Morbi imperdiet augue
quis tellus.

HTML and CSS are our tools. Mauris a ante. Suspendisse quam sem,
consequat at, commodo vitae, feugiat in, nunc. Morbi imperdiet augue
quis tellus. Praesent mattis, massa quis luctus fermentum, turpis mi
volutpat justo, eu volutpat enim diam eget metus.

{% highlight ruby %}
module Jekyll
  class TagIndex < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_index.html')
      self.data['tag'] = tag
      tag_title_prefix = site.config['tag_title_prefix'] || 'Tagged: '
      tag_title_suffix = site.config['tag_title_suffix'] || '&#8211;'
      self.data['title'] = "#{tag_title_prefix}#{tag}"
      self.data['description'] = "An archive of posts tagged #{tag}."
    end
  end
end
{% endhighlight %}
