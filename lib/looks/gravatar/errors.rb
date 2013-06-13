require 'looks/error'

module Looks
  module Gravatar

    class AuthenticationError < Error

      def to_s
        "Invalid email address or password"
      end

    end

    class IncorrectMethodParameterError < Error
    end

    class InternalError < Error
    end

    class UnknownError < Error

      def initialize(fault_code)
        @fault_code = fault_code
      end

      def to_s
        "Unknown error (#{@fault_code})"
      end

    end

  end
end
