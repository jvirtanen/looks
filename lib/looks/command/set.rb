require 'looks/command/account_management'
require 'looks/error'
require 'looks/gravatar'

module Looks
  module Command
    class Set < AccountManagement

      def arguments
        [ '<address>', '<id>' ]
      end

      def execute(args)
        super

        address, id = args

        account = Gravatar::Account.new(config)

        begin
          account.use_image(address, id)
        rescue Gravatar::IncorrectMethodParameterError
          addresses = account.addresses.map { |address| address.email }

          if addresses.include? address
            raise Error, "#{id}: Unknown identifier"
          else
            raise Error, "#{address}: Unknown email address"
          end
        end
      end

    end
  end
end
