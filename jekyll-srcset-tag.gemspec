# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll/srcset_tag/version'

Gem::Specification.new do |gem|
  gem.name          = 'jekyll-srcset-tag'
  gem.version       = Jekyll::SrcsetTag::VERSION
  gem.authors       = ['Kevin Dew']
  gem.email         = ['kevindew@me.com']
  gem.description   = 'Provides a block that can take a source image and generate it to all sizes for srcset usage'
  gem.summary       = 'A Jekyll plugin to use img srcset-w images'
  gem.homepage      = 'https://github.com/kevindew/jekyll-srcset-tag'
  gem.license       = 'MIT'

  all_files         = `git ls-files -z`.split("\x0")
  gem.files         = all_files.grep(%r{^lib/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 2.1.0'
  gem.add_runtime_dependency 'jekyll', '>= 2.0.0'
  gem.add_dependency 'nokogiri', '~> 1.6'
  gem.add_dependency 'mini_magick', '~> 4.3'

end