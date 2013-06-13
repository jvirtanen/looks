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
