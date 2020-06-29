Then(/^show me the cookies!$/) do
  show_me_the_cookies
end

Then(/^show me the "([^"]*)" cookie$/) do |cookie_name|
  show_me_the_cookie(cookie_name)
end

Given(/^I close my browser \(clearing the session\)$/) do
  expire_cookies
end
