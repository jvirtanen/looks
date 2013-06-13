module Looks
  module Gravatar
    class Image
      include Comparable

      def self.new_from_addresses(value)
        id     = value['userimage']
        url    = value['userimage_url']
        rating = value['rating']

        new(id, url, rating)
      end

      def self.new_from_images(key, value)
        id     = key
        url    = value[1]
        rating = value[0]

        new(id, url, rating)
      end

      attr_accessor :id, :url, :rating

      def initialize(id, url, rating)
        @id     = id
        @url    = url
        @rating = rating
      end

      def <=>(other)
        id <=> other.id
      end

      def to_s
        id
      end

    end
  end
end
