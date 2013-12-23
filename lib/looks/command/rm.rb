require 'looks/command/account_management'
require 'looks/gravatar'

module Looks
  module Command
    class Rm < AccountManagement

      def arguments
        [ '<image>' ]
      end

      def execute(args)
        super

        image = args.first

        begin
          Gravatar::Account.new(config).delete_image(image)
        rescue Gravatar::IncorrectMethodParameterError
          raise Error, "#{image}: Unknown identifier"
        end
      end

    end
  end
end
