require_relative 'image'
require_relative 'image/source'
require 'nokogiri'

module Jekyll
  module SrcsetTag
    class SrcsetTag < Liquid::Block

      def initialize(tag_name, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        render_markup = Liquid::Template.parse(@markup)
                                        .render(context)
                                        .gsub(/\\\{\\\{|\\\{\\%/, '\{\{' => '{{', '\{\%' => '{%')

        settings = srcset_settings(context)
        site = context.registers[:site]
        site.config['keep_files'] << settings['output'] unless site.config['keep_files'].include?(settings['output'])

        image = image File.join(site.source, settings['source']),
                      File.join(site.dest, settings['output']),
                      '/' + settings['output'],
                      render_markup,
                      sources(super)
        image.generate_images!
        image.to_html
      end

      protected

      def sources(content)
        # return sources objects
        html = Nokogiri::HTML(content)
        html.css('source').map do |source|
          Image::Source.new(width: source.attr('width'),
                            height: source.attr('height'),
                            media: source.attr('media'),
                            size: source.attr('size'),
                            fallback: source.attr('fallback') == 'true')
        end
      end

      def image(source_path, output_path, web_output_path, markup, sources)
        markup = markup_regex.match(markup)
        unless markup
          raise "srcset tag doesn't look right - it should be {% srcset image_src [ppi:1,2] [html_attributes] %}"
        end
        Image.new(source_path: source_path,
                  output_path: output_path,
                  web_output_path: web_output_path,
                  image_path: markup[:image_src],
                  ppi: markup[:ppi] || 1,
                  sources: sources,
                  html_attributes: markup[:html_attr])
      end

      def markup_regex
        %r{
          ^
          (?<image_src>[^\s]+\.[a-zA-Z0-9]{3,4})
          \s*
          (ppi:(?<ppi>(\d(\.\d\d?)?,)*\d(\.\d\d?)?))?
          \s*
          (?<html_attr>[\s\S]+)?
          $
        }x
      end

      def srcset_settings(context)
        settings = context.registers[:site].config['srcset']
        settings ||= {}
        settings['source'] ||= '_assets/images/fullsize'
        settings['output'] ||= 'images/generated'
        settings
      end

      def register_regenerate(context, image)
        site = context.registers[:site]
        if context.registers[:page] and context.registers[:page].has_key? 'path'
          site.regenerator.add_dependency site.in_source_dir(context.registers[:page]['path']),
                                          image.source_image_path
        end
      end
    end
  end
end
