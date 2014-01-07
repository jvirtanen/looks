require 'looks/error'

require 'inifile'

module Looks
  class Config

    def self.filename
      File.join(ENV['HOME'], '.looks')
    end

    def self.load
      begin
        new(IniFile.new(:filename => filename))
      rescue IniFile::Error
        raise Error, "#{filename}: Invalid file format"
      end
    end

    def address
      user['address']
    end

    def address=(address)
      user['address'] = address
    end

    def password
      user['password']
    end

    def password=(password)
      user['password'] = password
    end

    def save
      create_file unless File.exists? Config.filename

      @ini.save
    end

    private

    def initialize(ini)
      @ini = ini
    end

    def user
      @ini['user']
    end

    def create_file
      FileUtils.touch(Config.filename)
      FileUtils.chmod(0600, Config.filename)
    end

  end
end
