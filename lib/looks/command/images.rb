require 'looks/command/account_management'
require 'looks/gravatar'

module Looks
  module Command
    class Images < AccountManagement

      def initialize(config)
        super

        @verbose = false
      end

      def configure(opts)
        super

        opts.on('-v', '--verbose', "Be verbose") do
          @verbose = true
        end
      end

      def execute(args)
        super

        account = Gravatar::Account.new(config)
        images  = account.userimages

        if @verbose
          addresses = account.addresses

          images.each do |image|
            puts "#{image.id}"
            addresses.select { |a| a.userimage == image }.each do |address|
              puts "  #{address}"
            end
          end
        else
          puts images
        end
      end

    end
  end
end
