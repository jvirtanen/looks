require 'looks/error'
require 'looks/gravatar/address'
require 'looks/gravatar/errors'
require 'looks/gravatar/userimage'

require 'base64'
require 'xmlrpc/client'

module Looks
  module Gravatar
    class Account

      def initialize(config)
        uri = Gravatar.api_url(config.address)

        @password = config.password
        @server   = XMLRPC::Client.new_from_uri(uri)
      end

      def addresses
        addresses = call('grav.addresses').map do |key, value|
          Address.new_from_addresses(key, value)
        end

        addresses.sort
      end

      def userimages
        userimages = call('grav.userimages').map do |key, value|
          Userimage.new_from_userimages(key, value)
        end

        userimages.sort
      end

      def save_data(data)
        call('grav.saveData', {
          'data' => Base64.encode64(data),
          'rating' => 0
        })
      end

      def delete_userimage(userimage)
        call('grav.deleteUserimage', {
          'userimage' => userimage
        })
      end

      def use_userimage(userimage, addresses)
        call('grav.useUserimage', {
          'userimage' => userimage,
          'addresses' => addresses
        })
      end

      def remove_image(addresses)
        call('grav.removeImage', {
          'addresses' => addresses
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
