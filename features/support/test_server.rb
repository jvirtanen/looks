require 'json'
require 'webrick'
require 'xmlrpc/server'

class TestServer

  def initialize(port, config_file)
    config  = JSON[IO.read(config_file)]
    servlet = XMLRPC::WEBrickServlet.new

    servlet.add_handler("grav.addresses") do |args|
      result = config['addresses'].map do |key, value|
        address = key
        data    = Hash.new

        userimage = config['userimages'][value]
        if userimage
          data['rating']        = userimage['rating']
          data['userimage']     = value
          data['userimage_url'] = userimage['url']
        else
          data['rating']        = 0
          data['userimage']     = ""
          data['userimage_url'] = "http://www.gravatar.com/avatar/.png"
        end

        [ address, data ]
      end

      Hash[result]
    end

    servlet.add_handler("grav.userimages") do |args|
      result = config['userimages'].map do |key, value|
        userimage = key
        rating    = value['rating']
        url       = value['url']

        [ userimage, [ rating, url ]]
      end

      Hash[result]
    end

    @server = WEBrick::HTTPServer.new(
      :AccessLog => [],
      :Logger    => WEBrick::Log.new(File::NULL),
      :Port      => port
    )
    @server.mount('/xmlrpc', servlet)
  end

  def start
    @server.start
  end

  def shutdown
    @server.shutdown
  end

end
