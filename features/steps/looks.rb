servers = {}

After do
  servers.each do |server, thread|
    server.shutdown
    thread.join
  end

  servers.clear
end

Given /^the file named "([^"]+)"$/ do |filename|
  path = File.join("features/support", filename)
  file = File.absolute_path(path)

  in_current_dir do
    FileUtils.cp file, Dir.pwd
  end
end

Given /^a test server is running$/ do
  server = TestServer.new(8080, "features/support/test_server.json")
  thread = Thread.new { server.start }

  servers[server] = thread
end

Given /^I wait for a file named "([^"]+)" to be created$/ do |filename|
  step "a file named \"#{filename}\" should exist"
end

Given /^I configure the default account$/ do
  step "I run `looks config` interactively"
  step "I type \"alice\""
  step "I type \"secret\""
  step "I wait for a file named \"HOME/.looks\" to be created"
end

Then /^the file named "([^"]+)" should not be world readable$/ do |filename|
  in_current_dir do
    File.should_not be_world_readable(filename)
  end
end
