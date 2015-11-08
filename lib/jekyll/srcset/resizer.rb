module Jekyll
  module Srcset
    module Resizer
      def self.resize(image, destination_dir, filename, width, height)
        FileUtils.mkdir_p(destination_dir) unless File.exist?(destination_dir)
        image.strip
        if image['format'] == 'JPEG'
          image.quality 80
          image.depth 8
          image.interlace "plane"
        end
        image.combine_options do |i|
          i.resize "#{width}x#{height}^"
          i.gravity "center"
          i.crop "#{width}x#{height}+0+0"
        end

        image.write File.join(destination_dir, filename)
      end
    end
  end
end
