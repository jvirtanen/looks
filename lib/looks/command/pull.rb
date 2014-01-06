require 'looks/command/base'
require 'looks/gravatar'

module Looks
  module Command
    class Pull < Base

      def arguments
        ['<address>']
      end

      def execute(args)
        super

        address = args.first

        puts Gravatar.download_url(address)
      end

    end
  end
end
