require 'looks/command/base'
require 'looks/config'
require 'looks/error'

require 'highline'

module Looks
  module Command
    class Config < Base

      def execute(args)
        highline = HighLine.new

        address  = highline.ask("  Email address: ")
        password = highline.ask("       Password: ") { |q| q.echo = '*' }

        config.address  = address
        config.password = password

        begin
          config.save
        rescue IOError, SystemCallError
          raise Error, "#{Looks::Config.filename}: Cannot write file"
        end
      end

    end

  end
end
