unless defined? Looks::VERSION
  $LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

  require 'looks/version'
end

Gem::Specification.new do |s|
  s.name        = "looks"
  s.version     = Looks::VERSION
  s.summary     = "Command line interface to Gravatar"
  s.description = "Control your Gravatar account from the command line."
  s.homepage    = "http://github.com/jvirtanen/looks"
  s.author      = "Jussi Virtanen"
  s.email       = "jussi.k.virtanen@gmail.com"
  s.license     = "MIT"

  s.files = Dir[ 'LICENSE', 'README.md', 'bin/*', 'lib/**/*.rb' ]

  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'highline', '~> 1.6'
  s.add_runtime_dependency 'inifile',  '~> 2.0'

  s.add_development_dependency 'aruba',              '~> 0.5'
  s.add_development_dependency 'cucumber',           '~> 1.3'
  s.add_development_dependency 'dimensions',         '~> 1.2'
  s.add_development_dependency 'rake',               '~> 10.0'
  s.add_development_dependency 'rspec-expectations', '~> 2.13'

  s.executables << 'looks'
end
