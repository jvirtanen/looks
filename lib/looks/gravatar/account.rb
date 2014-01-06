require 'looks/error'
require 'looks/gravatar/address'
require 'looks/gravatar/errors'
require 'looks/gravatar/image'

require 'base64'
require 'xmlrpc/client'

module Looks
  module Gravatar
    class Account

      def initialize(config)
        @password = config.password
        @server   = XMLRPC::Client.new_from_uri(Gravatar.url(config.address))
      end

      def addresses
        addresses = call('grav.addresses').map do |key, value|
          Address.new_from_addresses(key, value)
        end

        addresses.sort
      end

      def images
        images = call('grav.userimages').map do |key, value|
          Image.new_from_images(key, value)
        end

        images.sort
      end

      def save_data(image)
        data = Base64.encode64(image)

        call('grav.saveData', { 'data' => data, 'rating' => 0 })
      end

      def delete_image(image)
        call('grav.deleteUserimage', { 'userimage' => image })
      end

      def use_image(address, id)
        call('grav.useUserimage', {
          'userimage' => id,
          'addresses' => [ address ]
        })
      end

      def remove_image(address)
        call('grav.removeImage', {
          'addresses' => [ address ]
        })
      end

      private

      def call(method, args = {})
        args['password'] = @password

        begin
          @server.call(method, args)
        rescue SocketError, SystemCallError
          raise Error, "Unable to connect to Gravatar server"
        rescue XMLRPC::FaultException => fault
          handle fault
        end
      end

      def handle(fault)
        case fault.faultCode
        when  -8
          raise InternalError
        when  -9
          raise AuthenticationError
        when -11
          raise IncorrectMethodParameterError
        else
          raise UnknownError, fault.faultCode
        end
      end

    end
  end
end
