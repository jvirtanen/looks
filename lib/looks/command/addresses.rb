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

        opts.on('-v', '--verbose', "Be verbose") do |address|
          @verbose = true
        end
      end

      def execute(args)
        super

        addresses = Gravatar::Account.new(config).addresses

        if @verbose
          addresses.each do |address|
            puts "#{address.email}"
            puts "  #{address.image.id}" unless address.image.nil?
          end
        else
          puts addresses
        end
      end

    end
  end
end
