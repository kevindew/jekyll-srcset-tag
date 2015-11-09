require 'jekyll/srcset_tag/srcset_tag'
require 'jekyll/srcset_tag/srcset_source_tag'

Liquid::Template.register_tag('srcset_source', Jekyll::SrcsetTag::SrcsetSourceTag)
Liquid::Template.register_tag('srcset', Jekyll::SrcsetTag::SrcsetTag)