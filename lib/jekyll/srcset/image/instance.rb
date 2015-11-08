module Jekyll
  module Srcset
    class Image::Instance

      attr_reader :width, :height, :image, :extension, :image_width, :image_height, :output_width, :output_height,
                  :undersized

      def initialize(width:, height:, extension:)
        @width = width
        @height = height
        @extension = extension
      end

      def for_image!(image)
        @image = image
        @image_width = image[:width].to_i
        @image_height = image[:height].to_i
        calculate_output_dimensions!
      end

      def filename
        output_width.to_s + 'x' + output_height.to_s + extension
      end

      def undersized?
        @undersized
      end

      protected

      # This is pretty much taken verbatim from https://github.com/robwierzbowski/jekyll-picture-tag
      def calculate_output_dimensions!
        @undersized = false
        image_ratio = image_width.to_f / image_height.to_f

        generated_width = if width
                            width.to_f
                          elsif height
                            image_ratio * height.to_f
                          else
                            image_width.to_f
                          end
        generated_height = if height
                             height.to_f
                           elsif width
                             width.to_f / image_ratio
                           else
                             image_height
                           end

        generated_ratio = generated_width / generated_height

        if image_width < generated_width || image_height < generated_height
          @undersized = true
          generated_width = if image_ratio > generated_ratio
                              image_width
                            else
                              image_height / generated_ratio
                            end
          generated_height = if image_ratio > generated_ratio
                               image_height
                             else
                               image_width / generated_ratio
                             end
        end

        @output_width = generated_width.round
        @output_height = generated_height.round
      end
    end
  end
end
