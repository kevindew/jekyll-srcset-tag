require 'jekyll/srcset/srcset_tag'
require 'jekyll/srcset/srcset_source_tag'

Liquid::Template.register_tag('srcset_source', Jekyll::Srcset::SrcsetSourceTag)
Liquid::Template.register_tag('srcset', Jekyll::Srcset::SrcsetTag)