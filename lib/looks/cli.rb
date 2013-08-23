require 'looks/command'
require 'looks/config'
require 'looks/error'

module Looks 
  module CLI

    USAGE = <<-EOF
Usage: looks <command> [arguments]

Commands:
  add        Upload an image
  addresses  List email addresses
  config     Configure the default account
  images     List uploaded images
  rm         Remove an uploaded image
  set        Set the image for an email address
  unset      Unset the image for an email address

    EOF

    COMMANDS = {
      'add'       => Command::Add,
      'addresses' => Command::Addresses,
      'config'    => Command::Config,
      'images'    => Command::Images,
      'rm'        => Command::Rm,
      'set'       => Command::Set,
      'unset'     => Command::Unset
    }

    def self.start(args)
      usage if args.empty?

      command = args.shift
      usage unless COMMANDS.include? command

      config = Config.load

      begin
        COMMANDS[command].new(config).run(args)
      rescue Error => e
        error(e)
      end
    end

    def self.usage
      abort USAGE
    end

    def self.error(message)
      abort "looks: error: #{message}"
    end

  end
end
