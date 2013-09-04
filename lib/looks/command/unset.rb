require 'looks/command/account_management'
require 'looks/error'
require 'looks/gravatar'

module Looks
  module Command
    class Unset < AccountManagement

      def arguments
        [ '<address>' ]
      end

      def execute(args)
        super

        address = args.first

        account = Gravatar::Account.new(config)

        begin
          account.remove_image(address)
        rescue Gravatar::IncorrectMethodParameterError
          raise Error, "#{address}: Unknown email address"
        end
      end

    end
  end
end
