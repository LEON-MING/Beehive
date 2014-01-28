Given /^I am logged in as "(.*)"$/ do |user|
  ***REMOVED***CASClient::Frameworks::Rails::Filter.fake(user)
  ***REMOVED***visit "/login"
  OmniAuth.config.add_mock(:cas, {
    :uid => user
  })
  visit "/auth/cas"
end

When /^I set "(.*)" as admin$/ do |user|
  t = User.find_by_login(user)
  t.user_type = 3
  t.save!
end

When /^I log out$/ do
  begin
    visit "/logout"
  rescue Exception=>e
  end
  visit "/"
end

Given /^I am signed in with provider "([^"]*)" as Justin$/ do |provider|
  OmniAuth.config.add_mock(:cas, {
    :uid => '758752'
  })
  visit "/auth/***REMOVED***{provider.downcase}"
end

Given /^I am signed in with provider "([^"]*)" as Justina$/ do |provider|
  OmniAuth.config.add_mock(:cas, {
    :uid => '1005472'
  })
  visit "/auth/***REMOVED***{provider.downcase}"
end

Given /^I am signed in with provider "([^"]*)" as Fox$/ do |provider|
  OmniAuth.config.add_mock(:cas, {
    :uid => '49538'
  })
  visit "/auth/***REMOVED***{provider.downcase}"
end

Given /^I am signed in with provider "([^"]*)" as Stoica$/ do |provider|
  OmniAuth.config.add_mock(:cas, {
    :uid => '174817'
  })
  visit "/auth/***REMOVED***{provider.downcase}"
end

Then /^I should see "(.*)" after "(.*)"$/ do |e1, e2|
  ***REMOVED***  ensure that that e1 occurs before e2.
  ***REMOVED***  page.content  is the entire content of the page as a string.
  regexp = /***REMOVED***{e2}.****REMOVED***{e1}/m
  assert_match regexp, page.body
end
