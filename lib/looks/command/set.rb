require 'looks/command/account_management'
require 'looks/error'
require 'looks/gravatar'

module Looks
  module Command
    class Set < AccountManagement

      def arguments
        [ '<address>', '<image>' ]
      end

      def execute(args)
        super

        address, image = args

        account = Gravatar::Account.new(config)

        begin
          account.use_userimage(image, [address])
        rescue Gravatar::IncorrectMethodParameterError
          addresses = account.addresses.map { |address| address.email }

          if addresses.include? address
            raise Error, "#{image}: Unknown identifier"
          else
            raise Error, "#{address}: Unknown email address"
          end
        end
      end

    end
  end
end
