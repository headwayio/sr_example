# rubocop:disable all

require 'uri'
require 'cgi'
require_relative '../../support/paths'
require_relative '../../support/selectors'

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When(/^(.*) within (.*[^:])$/) do |step, parent|
  with_scope(parent) { step step }
end

# Multi-line step scoper
When(/^(.*) within (.*[^:]):$/) do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

When(/^(?:|I )follow "([^"]*)"$/) do |link|
  click_link(link)
end

When(/^(?:|I )trigger a click on "([^"]*)"$/) do |link|
  find(link).trigger('click')
end

When(/^(?:|I )press "([^"]*)"$/) do |button|
  click_button(button)
end

Given(/^(?:|I )am on (?!.*page object)(.+)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )go to (?!.*page object)(.+)$/) do |page_name|
  visit path_to(page_name)
end

Then(/^(?:|I )should be on (.+)$/) do |page_name|
  current_path = nil
  expected_path = path_to page_name

  begin
    current_path = URI.parse(current_url).path
    SitePrism::Waiter.wait_until_true { current_path == expected_path }
  rescue SitePrism::TimeoutException
    warn "expected: #{expected_path}, got: #{current_path}"
    raise
  end
end

# Then(/^(?:|I )should be on (.+)$/) do |page_name|
#   current_path = URI.parse(current_url).path
#   expect(current_path).to eq(path_to(page_name))
# end

Then(/^(?:|I) should have access to to an active button labeled "([^"]*)" which takes me to (?!.*page object)(.+)$/) do |button_label, page_name|
  page.should have_link(button_label, href: path_to(page_name))
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
  page.should have_content(text)
end

Then(/^(?:|I )should not see "([^"]*)"$/) do |text|
  page.should have_no_content(text)
end

When(/^I confirm the alert popup$/) do
  page.find('#confirmation-modal .confirm').click
end

When(/^I dismiss the alert popup$/) do
  page.find('#confirmation-modal .cancel').click
end

Then(/^I should see a table with (\d+) rows in addition to the header$/) do |count|
  expect(page.all(:css, 'tr').length).to eq(count.to_i + 1)
end

When(/^(?:|I )check "([^"]*)"$/) do |field|
  check(field)
end

When(/^(?:|I )uncheck "([^"]*)"$/) do |field|
  uncheck(field)
end

When(/^(?:|I )choose "([^"]*)"$/) do |field|
  choose(field)
end

Then(/^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    expect(field_value).to match(/#{value}/)
  end
end

Then(/^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    expect(field_value).to_not match(/#{value}/)
  end
end

Then(/^the "([^"]*)" checkbox(?: within (.*))? should be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    expect(field_checked).to be_true
  end
end

Then(/^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    expect(field_checked).to be_false
  end
end

When(/^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/) do |path, field|
  attach_file(field, File.expand_path(path))
end

When(/^(?:|I )select "([^"]*)" from "([^"]*)"$/) do |value, field|
  select(value, from: field)
end

When(/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^I press the (.+) key$/) do |key|
  find('body').native.send_keys(key.to_sym)
end

When(/^I follow the icon link "([^"]*)"$/) do |data_subject|
  find(:xpath, "//a[@data-subject = '#{data_subject}']").click
end

When(/^I follow the image link "([^"]*)"$/) do |img_alt|
  # matches on alt text or title
  find(:xpath, "//img[@alt = '#{img_alt}']/parent::a |(//img[@title = '#{img_alt}']/parent::a").click
end

Then(/^(?:|I )should have the following query string:$/) do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair { |k, v| expected_params[k] = v.split(',') }

  expect(actual_params).to eq(expected_params)
end

When(/^I reload the page$/) do
  visit current_path
end

Then(/^the CSV should be downloaded$/) do
  expect(page.response_headers['Content-Type']).to eq('text/csv')
end

Given(/^I press "([^"]*)" in a row containing "([^"]*)"$/) do |button, name|
  page.find('tr', text: name).click_button(button)
end
