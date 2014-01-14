require 'looks/error'
require 'looks/version'

require 'optparse'

module Looks
  module Command
    class Base

      attr_reader :config

      def initialize(config)
        @opts   = OptionParser.new
        @config = config

        configure(@opts)
        set_banner
        set_version
      end

      def run(args)
        begin
          @opts.parse! args
        rescue OptionParser::ParseError => e
          raise Error, e
        end

        usage unless args.length == arguments.length

        execute(args)
      end

      def usage
        abort to_s
      end

      def to_s
        "#{@opts.help}\n"
      end

      protected

      def arguments
        []
      end

      def configure(opts)
        opts.separator ""
        opts.separator "Options:"

        opts.on_tail('-h', '--help', 'Show this help') do |help|
          puts to_s
          exit
        end
      end

      def execute(args)
      end

      private

      def name
        self.class.name.split('::').last.downcase
      end

      def set_banner
        program_name = @opts.program_name
        command_name = name

        banner = "Usage: #{program_name} #{command_name}"

        banner += " [options]"
        banner += " #{arguments.join(' ')}" unless arguments.empty?

        @opts.set_banner banner
      end

      def set_version
        @opts.version = VERSION
      end

    end
  end
end
