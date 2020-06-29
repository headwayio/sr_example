Then(/^I should see today's date in (.+) form$/) do |date_format|
  format = date_format.parameterize.underscore
  text = Time.zone.today.to_s(format.to_sym)
  expect(page).to have_content(text)
end

Given(/^the date is "(.*?)"$/) do |date|
  Timecop.travel(Date.parse(date))
end

Given(/^(.*) days? (?:pass|passes)$/) do |number_of|
  timecop_travel number_of.to_i.days.from_now
end
