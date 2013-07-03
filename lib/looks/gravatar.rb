require 'looks/gravatar/account'
require 'looks/gravatar/address'
require 'looks/gravatar/errors'
require 'looks/gravatar/image'

require 'digest/md5'

module Looks
  module Gravatar

    URL = ENV['LOOKS_GRAVATAR_URL'] || 'https://secure.gravatar.com/xmlrpc'

    def self.hash(email)
      Digest::MD5.hexdigest(email.strip.downcase)
    end

    def self.url(email)
      "#{URL}?user=#{hash(email)}"
    end

  end
end
