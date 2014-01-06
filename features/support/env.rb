require 'aruba/cucumber'

Before do
  set_env('HOME', File.expand_path(File.join(current_dir, 'HOME')))

  set_env('LOOKS_GRAVATAR_API_URL',      'http://localhost:8080/xmlrpc')
  set_env('LOOKS_GRAVATAR_DOWNLOAD_URL', 'http://localhost:8080/avatar')

  FileUtils.mkdir_p ENV['HOME']
end
