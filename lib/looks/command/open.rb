require 'looks/command/base'
require 'looks/gravatar'

require 'launchy'

module Looks
  module Command
    class Open < Base

      def initialize(config)
        super

        @display = false
      end

      def arguments
        ['<address>']
      end

      def configure(opts)
        super

        opts.on('-u', '--url', "Only display the URL of the uploaded image") do
          @display = true
        end
      end

      def execute(args)
        super

        address = args.first

        url = Gravatar.download_url(address)

        if @display
          puts url
        else
          begin
            Launchy.open(url)
          rescue Launchy::Error
            puts url
          end
        end
      end

    end
  end
end
