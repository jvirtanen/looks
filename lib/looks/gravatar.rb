require 'looks/gravatar/account'
require 'looks/gravatar/address'
require 'looks/gravatar/errors'
require 'looks/gravatar/userimage'

require 'digest/md5'
require 'net/http'
require 'uri'

module Looks
  module Gravatar

    DEFAULT_API_URL      = 'https://secure.gravatar.com/xmlrpc'
    DEFAULT_DOWNLOAD_URL = 'http://gravatar.com/avatar'

    API_URL      = ENV['LOOKS_GRAVATAR_API_URL']      || DEFAULT_API_URL
    DOWNLOAD_URL = ENV['LOOKS_GRAVATAR_DOWNLOAD_URL'] || DEFAULT_DOWNLOAD_URL

    def self.get(email)
      Net::HTTP.get(URI("#{DOWNLOAD_URL}/#{hash(email)}.jpg"))
    end

    def self.hash(email)
      Digest::MD5.hexdigest(email.strip.downcase)
    end

    def self.url(email)
      "#{API_URL}?user=#{hash(email)}"
    end

  end
end
