# Jekyll Srcset

This gem allows you to use the [srcset]() variety of responsive images in your Jekyll project. 
It takes a path to a fullsize image and will generate resized images at the sizes and ppi's specified in your jekyll output.

It's still early days on this, seems to work in a quick build, but we're getting started putting it through something more substantial that should help improve it.

It borrows heavily from the work done in [Jekyll Picture-tag](https://github.com/robwierzbowski/jekyll-picture-tag) by Rob Wierzbowski - It's origins lie in a messy hacked version of that plugin. This differs by supporting srcset and a few other tweaks that resolved some of the problems I was having with it.

## Installation

### Bundler

#### Already Have a Gemfile?

Add the following to your `Gemfile`

    gem 'jekyll-srcset', '~> 0.1'

Then run

    $ bundle install

#### No Gemfile?

Create a plugin to load bundler gems in your `_plugins` directory

    # _plugins/bundler.rb
    require "rubygems"
    require "bundler/setup"
    Bundler.require(:default)

Create a `Gemfile`

    # Gemfile
    source 'https://rubygems.org'
    gem 'jekyll-srcset', '~> 0.1'

Then run

    $ bundle install      

### System Gem

Install the gem
    
    gem install 'jekyll-srcset'

Create a plugin for it

    # _plugins/jekyll_srcset.rb
    require "rubygems"
    require "jekyll-srcset"

## Usage

### Set up your config

By default this plugin expects to find your source images to be relative to your file directory and will output them in an 
images/generated directory.

You can tweak this in your config

    # _config.yml
    srcset:
        source: _assets/images/fullsize
        output: images/resized

### Put it in your liquid templates

Example syntax:

    {% srcset _assets/images/fullsize/movies/terminator.jpg ppi:1,2 alt='Terminator' %}
        {% srcset_source media:'(min-width: 400px)' size:'512px' width:512 %}
        {% srcset_source width:320 %}
    {% endsrcset %}

This will generate the following HTML

    <img src="/images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/320x256.jpg" srcset="/images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/1024x819.jpg 1024w, /images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/512x410.jpg 512w, /images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/640x512.jpg 640w, /images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/320x256.jpg 320w" sizes="(min-width: 400px) 512px, 100vw" alt='Terminator' />    

And the following images

    .jekyll/images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/320x256.jpg
    .jekyll/images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/512x410.jpg
    .jekyll/images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/640x512.jpg
    .jekyll/images/generated/_assets/images/fullsize/movies/terminator.jpg-5c03014/1024x819.jpg

The syntax for `srcset` is `{% srcset path/to/your/image.jpg [ppi:x,y,z] [html attributes] %}{% endsrcset %}`

The syntax for `srcset_source` is {% srcset_source [media:string] [size:string] [width:int] [height:int] %}

## Contribute

Please do in anyway you like - I bet making this doc better would be a good place to start. Pull requests welcome.

## License

MIT

