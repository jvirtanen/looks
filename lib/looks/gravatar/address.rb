require 'looks/gravatar/image'

module Looks
  module Gravatar
    class Address
      include Comparable

      def self.new_from_addresses(key, value)
        email = key
        image = Image.new_from_addresses(value)

        new(email, image)
      end

      attr_reader :email, :image

      def initialize(email, image)
        @email = email
        @image = image
      end

      def <=>(other)
        email <=> other.email
      end

      def to_s
        email
      end

    end
  end
end
