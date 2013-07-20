require 'base64'
require 'digest'
require 'dimensions'
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

    servlet.add_handler("grav.useUserimage") do |args|
      userimage = args['userimage']
      addresses = args['addresses']

      method_parameter_missing unless userimage
      method_parameter_missing unless addresses

      unknown_addresses = addresses.select do |address|
        not config['addresses'].include? address
      end

      method_parameter_incorrect unless config['userimages'].include? userimage
      method_parameter_incorrect unless unknown_addresses.empty?

      addresses.each do |address|
        config['addresses'][address] = userimage
      end

      result = addresses.map do |address|
        [ address, true ]
      end

      Hash[result]
    end

    servlet.add_handler("grav.saveData") do |args|
      data   = args['data']
      rating = args['rating']

      method_parameter_missing unless data
      method_parameter_missing unless rating

      image = Base64.decode64(data)

      misc_error("Not an image") unless image? image

      userimage = Digest::MD5.hexdigest(image)

      config['userimages'][userimage] = {
        'rating' => rating,
        'url'    => "http://www.gravatar.com/avatar/#{userimage}.png"
      }

      userimage
    end

    servlet.add_handler("grav.deleteUserimage") do |args|
      userimage = args['userimage']

      method_parameter_missing   unless userimage
      method_parameter_incorrect unless config['userimages'].include? userimage

      config['userimages'].delete(userimage)

      new_addresses = config['addresses'].map do |key, value|
        if value == userimage
          [ key, nil ]
        else
          [ key, value ]
        end
      end

      config['addresses'] = Hash[new_addresses]

      true
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

  private

  def image?(data)
    not Dimensions(StringIO.new(data)).tap { |io| io.read }.width.nil?
  end

  def method_parameter_missing
    raise XMLRPC::FaultException.new(-10, "Method parameter missing")
  end

  def method_parameter_incorrect
    raise XMLRPC::FaultException.new(-11, "Method parameter incorrect")
  end

  def misc_error(message)
    raise XMLRPC::FaultException.new(-100, message)
  end

end
