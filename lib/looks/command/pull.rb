require 'looks/command/base'
require 'looks/error'
require 'looks/gravatar'

module Looks
  module Command
    class Pull < Base

      def arguments
        ['<address>', '<filename>']
      end

      def execute(args)
        super

        address, filename = args

        begin
          File.open(filename, 'wb') do |file|
            file.write(Gravatar.get(address))
          end
        rescue IOError, SystemCallError
          raise Error, "#{filename}: Cannot write file"
        end
      end

    end
  end
end
