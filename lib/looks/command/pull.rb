require 'looks/command/base'
require 'looks/error'
require 'looks/gravatar'

require 'net/http'
require 'uri'

module Looks
  module Command
    class Pull < Base

      def arguments
        ['<address>', '<filename>']
      end

      def execute(args)
        super

        address, filename = args

        download_url = Gravatar.download_url(address)

        begin
          File.open(filename, 'wb') do |file|
            file.write(Net::HTTP.get(URI(download_url)))
          end
        rescue IOError, SystemCallError
          raise Error, "#{filename}: Cannot write file"
        end
      end

    end
  end
end
