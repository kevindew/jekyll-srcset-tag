module Jekyll
  module SrcsetTag
    class Image::Source

      attr_reader :media, :size, :width, :height

      def initialize(width: nil, height: nil, media: nil, size: nil)
        @media = media
        @size = size
        @width = width
        @height = height
      end

      def size_string
        (media ? media + ' ' : '') + (size || '100vw')
      end

    end
  end
end
