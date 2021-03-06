require 'looks/gravatar/account'
require 'looks/gravatar/address'
require 'looks/gravatar/errors'
require 'looks/gravatar/userimage'

require 'digest/md5'

module Looks
  module Gravatar
    module_function

    DEFAULT_API_URL      = 'https://secure.gravatar.com/xmlrpc'
    DEFAULT_DOWNLOAD_URL = 'http://gravatar.com/avatar'

    API_URL      = ENV['LOOKS_GRAVATAR_API_URL']      || DEFAULT_API_URL
    DOWNLOAD_URL = ENV['LOOKS_GRAVATAR_DOWNLOAD_URL'] || DEFAULT_DOWNLOAD_URL

    def api_url(email)
      "#{API_URL}?user=#{hash(email)}"
    end

    def download_url(email)
      "#{DOWNLOAD_URL}/#{hash(email)}"
    end

    def hash(email)
      Digest::MD5.hexdigest(email.strip.downcase)
    end

  end
end
