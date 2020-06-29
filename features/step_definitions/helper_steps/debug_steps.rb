# Debug
When(/^I dump.* the response$/) do
  puts body
end

Then(/^(?:p|P)ry$/) do
  require 'pry'
  binding.pry # rubocop:disable Lint/Debugger
end

Then(/^I wait (\d+) (?:second|seconds)$/) do |time|
  STDERR.print "!!!!sleeping #{time} seconds!!!!!"
  sleep time.to_i
end

Then(/^save page$/) do
  path_to_page = save_page
  puts `cat #{path_to_page}`
end

Then(/^I debug the page$/) do
  page.driver.debug
end

Then(/^show me the page|save and open page$/) do
  save_and_open_page # rubocop:disable Lint/Debugger
end
