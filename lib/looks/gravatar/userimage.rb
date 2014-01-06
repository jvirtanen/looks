module Looks
  module Gravatar
    class Userimage
      include Comparable

      def self.new_from_addresses(value)
        id = value['userimage']

        if not id.empty?
          url    = value['userimage_url']
          rating = value['rating']

          new(id, url, rating)
        else
          nil
        end
      end

      def self.new_from_userimages(key, value)
        id     = key
        url    = value[1]
        rating = value[0]

        new(id, url, rating)
      end

      attr_reader :id, :url, :rating

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
