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
      authenticate(args, config)

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

        [address, data]
      end

      Hash[result]
    end

    servlet.add_handler("grav.userimages") do |args|
      authenticate(args, config)

      result = config['userimages'].map do |key, value|
        userimage = key
        rating    = value['rating']
        url       = value['url']

        [userimage, [rating, url]]
      end

      Hash[result]
    end

    servlet.add_handler("grav.useUserimage") do |args|
      authenticate(args, config)

      userimage = args['userimage']
      addresses = args['addresses']

      method_parameter_missing unless userimage
      method_parameter_missing unless addresses

      method_parameter_incorrect unless config['userimages'].include? userimage

      unless unknown_addresses(addresses, config).empty?
        method_parameter_incorrect
      end

      addresses.each do |address|
        config['addresses'][address] = userimage
      end

      result = addresses.map do |address|
        [address, true]
      end

      Hash[result]
    end

    servlet.add_handler("grav.removeImage") do |args|
      authenticate(args, config)

      addresses = args['addresses']

      method_parameter_missing unless addresses

      unless unknown_addresses(addresses, config).empty?
        method_parameter_incorrect
      end

      addresses.each do |address|
        config['addresses'][address] = nil
      end

      result = addresses.map do |address|
        [address, true]
      end

      Hash[result]
    end

    servlet.add_handler("grav.saveData") do |args|
      authenticate(args, config)

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
      authenticate(args, config)

      userimage = args['userimage']

      method_parameter_missing   unless userimage
      method_parameter_incorrect unless config['userimages'].include? userimage

      config['userimages'].delete(userimage)

      new_addresses = config['addresses'].map do |key, value|
        if value == userimage
          [key, nil]
        else
          [key, value]
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

  def authenticate(args, config)
    authentication_error if args['password'] != config['credentials']['password']
  end

  def unknown_addresses(addresses, config)
    addresses.select do |address|
      not config['addresses'].include? address
    end
  end

  def authentication_error
    raise XMLRPC::FaultException.new(-9, "Authentication error")
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
