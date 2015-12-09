require 'cgi'

module Jekyll
  module SrcsetTag
    class SrcsetSourceTag < Liquid::Tag

      def initialize(tag_name, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        render_markup = Liquid::Template.parse(@markup)
                                        .render(context)
                                        .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')
        hash = markup_to_hash(render_markup)
        markup = hash.map { |(key, value)| "#{key}=\"#{CGI.escape_html(value)}\""}
        '<source ' + markup.join(' ') +  ' />'
      end

      protected

      def markup_to_hash(markup)
        matches = markup.scan(markup_regex)
        matches.each_with_object({}) do |match, memo|
          key, value = match.split(':', 2)
          memo[key.strip] = value.gsub(/\A("|')|("|')\Z/, '')
        end
      end

      def markup_regex
        %r{
          \w+
          \s*
          \:
          \s*
          (?:
            "(?:[^"\\]|\\.)*"
            |
            '(?:[^'\\]|\\.)*'
            |
            [^\s]+
          )
        }x
      end
    end
  end
end
