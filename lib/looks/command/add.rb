require 'looks/command/account_management'
require 'looks/error'
require 'looks/gravatar'

module Looks
  module Command
    class Add < AccountManagement

      def arguments
        [ '<filename>' ]
      end

      def execute(args)
        super

        filename = args.first

        raise Error, "#{filename}: File not found" unless File.exists? filename

        begin
          File.open(filename) do |file|
            puts Gravatar::Account.new(config).add(file.read)
          end
        rescue IOError, SystemCallError
          raise Error, "#{filename}: Cannot read file"
        end
      end

    end
  end
end
