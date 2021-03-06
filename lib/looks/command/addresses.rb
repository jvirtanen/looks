require 'looks/command/account_management'
require 'looks/gravatar'

module Looks
  module Command
    class Addresses < AccountManagement

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

        addresses = Gravatar::Account.new(config).addresses

        if @verbose
          addresses.each do |address|
            puts "#{address.email}"
            puts "  #{address.userimage.id}" unless address.userimage.nil?
          end
        else
          puts addresses
        end
      end

    end
  end
end
