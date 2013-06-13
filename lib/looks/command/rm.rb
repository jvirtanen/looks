require 'looks/command/account_management'
require 'looks/gravatar'

module Looks
  module Command
    class Rm < AccountManagement

      def arguments
        [ '<id>' ]
      end

      def execute(args)
        super

        id = args.first

        begin
          Gravatar::Account.new(config).remove(id)
        rescue Gravatar::IncorrectMethodParameterError
          raise Error, "#{id}: Unknown identifier"
        end
      end

    end
  end
end
