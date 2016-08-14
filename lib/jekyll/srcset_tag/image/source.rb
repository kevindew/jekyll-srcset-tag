module Jekyll
  module SrcsetTag
    class Image::Source

      attr_reader :media, :size, :width, :height, :fallback

      def initialize(width: nil, height: nil, media: nil, size: nil, fallback: nil)
        @media = media
        @size = size
        @width = width
        @height = height
        @fallback = fallback
      end

      def size_string
        (media ? media + ' ' : '') + (size || '100vw')
      end

    end
  end
end
