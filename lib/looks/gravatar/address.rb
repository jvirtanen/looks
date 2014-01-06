require 'looks/gravatar/userimage'

module Looks
  module Gravatar
    class Address
      include Comparable

      def self.new_from_addresses(key, value)
        email     = key
        userimage = Userimage.new_from_addresses(value)

        new(email, userimage)
      end

      attr_reader :email, :userimage

      def initialize(email, userimage)
        @email     = email
        @userimage = userimage
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
