require 'looks/command/base'

module Looks
  module Command
    class AccountManagement < Base

      def configure(opts)
        super

        opts.on('-e', '--email ADDRESS', "Gravatar email address") do |address|
          config.address = address
        end

        opts.on('-p', '--password PASSWORD', "Gravatar password") do |password|
          config.password = password
        end
      end

      def execute(args)
        usage unless config.address && config.password
      end

    end
  end
end
