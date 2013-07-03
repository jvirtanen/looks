require 'aruba/cucumber'

Before do
  set_env('HOME', File.expand_path(File.join(current_dir, 'HOME')))

  set_env('LOOKS_GRAVATAR_URL', 'http://localhost:8080/xmlrpc')

  FileUtils.mkdir_p ENV['HOME']
end
