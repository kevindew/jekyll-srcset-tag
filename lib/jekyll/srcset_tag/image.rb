require 'digest/sha1'
require 'cgi'
require 'mini_magick'
require_relative 'resizer'

module Jekyll
  module SrcsetTag
    class Image

      attr_reader :source_path, :output_path, :web_output_path, :image_path, :ppi, :sources, :html_attributes

      def initialize(source_path:, output_path:, web_output_path:, image_path:, ppi:, sources:, html_attributes:)
        @source_path = source_path
        @output_path = output_path
        @web_output_path = web_output_path
        @image_path = image_path
        @ppi = ppi.respond_to?(:sort_by) ? ppi : ppi.split(',').map(&:to_i)
        @sources = sources
        @html_attributes = html_attributes
      end

      def generate_images!
        needed_instances = uniq_instances.select { |instance| !File.exist?(File.join(output_dir, instance.filename)) }
        resize_images! needed_instances
      end

      def instances
        @instances ||= create_instances
      end

      def uniq_instances
        instances.uniq { |instance| [ instance.output_width, instance.output_height ] }
      end

      def to_html
        srcs = image_srcs
        src = CGI.escape_html(srcs.last[0])
        show_srcset = srcs.length > 1
        srcset = CGI.escape_html(srcs.map {|path, size| "#{path} #{size}w" }.join(', '))
        sizes = CGI::escape_html(source_sizes.join(', '))
        srcset_attrs = show_srcset ? " srcset=\"#{srcset}\" sizes=\"#{sizes}\"" : ''
        "<img src=\"#{src}\"#{srcset_attrs} #{html_attributes}/>\n"
      end

      def digest
        unless @digest
          file = Digest::SHA1.file(File.join(source_path, image_path)).to_s
          sizes = Digest::SHA1.hexdigest instances.map { |i| i.width.to_s + '-' + i.height.to_s }.join(' ')
          @digest = Digest::SHA1.hexdigest file + sizes
        end
        @digest
      end

      def output_dir
        File.join(output_path, image_path + '-' + digest.slice(0, 7))
      end

      def web_output_dir
        File.join(web_output_path, image_path + '-' + digest.slice(0, 7))
      end

      def source_image_path
        File.join(source_path, image_path)
      end

      def output_image_paths
        uniq_instances.map { |instance| File.join(output_dir, instance.filename)}
      end      

      protected

      def create_instances
        reverse_ppi = ppi.sort_by { |s| -s }
        all_sources = sources.map do |source|
          reverse_ppi.map { |ppi| [source, ppi] }
        end.flatten(1)
        original = MiniMagick::Image.open File.join(source_path, image_path)
        all_sources.map do |(source, ppi)|
          Instance.new width: (source.width ? (source.width.to_f * ppi).round : nil),
                       height: (source.height ? (source.height.to_f * ppi).round : nil),
                       extension: File.extname(image_path),
                       image: original
        end
      end

      def image_srcs
        uniq_instances.map do |instance|
          [File.join(web_output_dir, instance.filename), instance.output_width.to_s]
        end
      end

      def source_sizes
        sources.map { |source| source.size_string }
      end

      def resize_images!(instances)
        if instances.any? { |i| i.undersized }
          warn "Warning:".yellow + " #{image_path} is smaller than the requested output file. " +
               "It will be resized without upscaling."
        end
        instances.each do |instance|
          Resizer::resize(instance.image, output_dir, instance.filename, instance.output_width, instance.output_height)
          puts "Generated #{File.join(output_dir, instance.filename)}"
        end
      end

    end
  end
end

require_relative 'image/instance'
