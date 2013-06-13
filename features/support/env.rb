require 'aruba/cucumber'

Before do
  set_env('HOME', File.expand_path(File.join(current_dir, 'HOME')))

  FileUtils.mkdir_p ENV['HOME']
end
