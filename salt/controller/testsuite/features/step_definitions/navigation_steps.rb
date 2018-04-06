
When(/^I wait until I see "([^"]*)" text$/) do |text|
  begin
    Timeout.timeout(DEFAULT_TIMEOUT) do
      loop do
        break if page.has_content?(text)
        sleep 3
      end
    end
  rescue Timeout::Error
    raise "Couldn't find the #{text} in webpage"
  end
end

When(/^I wait until I see "([^"]*)" text, refreshing the page$/) do |text|
  begin
    Timeout.timeout(DEFAULT_TIMEOUT) do
      loop do
        break if page.has_content?(text)
        sleep 1
        page.evaluate_script 'window.location.reload()'
      end
    end
  rescue Timeout::Error
    raise "Couldn't find the #{text} in webpage"
  end
end


When(/^I wait until I do not see "([^"]*)" text, refreshing the page$/) do |text|
  begin
    Timeout.timeout(DEFAULT_TIMEOUT) do
      loop do
        break unless page.has_content?(text)
        sleep 3
        page.evaluate_script 'window.location.reload()'
      end
    end
  rescue Timeout::Error
    raise "The #{text} was always there in webpage"
  end
end


#
# Check a checkbox of the given id
#
When(/^I check "([^"]*)"$/) do |box|
  check(box)
end

When(/^I uncheck "([^"]*)"$/) do |box|
  uncheck(box)
end


#
# Click on a button
#
When(/^I click on "([^"]*)"$/) do |button|
  begin
    click_button button, match: :first
  rescue
    sleep 4
    click_button button, match: :first
  end
end
#
# Click on a button and confirm in alert box
When(/^I click on "([^"]*)" and confirm$/) do |button|
  accept_alert do
    step %(I click on "#{button}")
    sleep 1
  end
end

#
# Click on a link
#
When(/^I follow "([^"]*)"$/) do |text|
  begin
    click_link(text)
  rescue
    sleep 3
    click_link(text)
  end
end

#
# Click on the first link
#
When(/^I follow first "([^"]*)"$/) do |text|
  click_link(text, match: :first)
end


# FIXME: this step need adaption
Given(/^I am authorized as "([^"]*)" with password "([^"]*)"$/) do |user, pwd|
  # visit webpage login
  visit Capybara.app_host
  fill_in 'username', with: user
  fill_in 'password', with: arg2
  click_button 'Sign In'
  step %(I should be logged in)
end

#
# Test for a text in the whole page
#
Then(/^I should see a "([^"]*)" text$/) do |arg1|
  unless page.has_content?(arg1)
    sleep 2
    raise unless page.has_content?(arg1)
  end
end


#
# Test for a text not allowed in the whole page
#
Then(/^I should not see a "([^"]*)" text$/) do |text|
  raise "#{text} found on the page! FAIL" unless page.has_no_content?(text)
end

