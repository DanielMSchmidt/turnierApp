Given /^user (\d+) without clubs$/ do |number|
  User.create!(email: "user#{number}@gmx.de", password: "testtest", password_confirmation: "testtest", remember_me: true, name: "User #{number}")
end

Given /^user (\d+) logges in$/ do |number|
  visit user_session_path
  within '#new_user' do
    fill_in 'Email', with: 'user#{number}@gmx.de'
    fill_in 'Password', with: 'testtest'
    click_on 'Anmelden'
  end

end

When /^I go to the clubs page$/ do
  visit clubs_path
end

When /^I add a club$/ do
  visit tournaments_path
  click_on 'Club Number 0 hinzufuegen'
end

Then /^should this club be a pending club$/ do
  page.should have_content 'Sie warten auf die Bestaetigung von Club Number 0'
end

Given /^user (\d+) with a club '(\S+)'$/ do |number, clubs_name|
  user = User.new(email: "user#{number}@gmx.de", password: "testtest", password_confirmation: "testtest", remember_me: true, name: "User #{number}")
  user.save!
  user.clubs.create!(name: clubs_name)
end

When /^I add the club '(\S+)'$/ do |club_name|
  click_on "#{club_name} hinzufuegen"
end

When /^I log out$/ do
  click_on "Abmelden"
end

Then /^user (\d+) should be shown as pending$/ do |number|
  page.should have_content "User #{number} moechte dem Verein beitreten"
end

Given /^there is (\d+) club$/ do |number|
  number.to_i.times{|x| Club.create!(name: "Club Number #{x}")}
end

When /^I go to profile page$/ do
  visit edit_user_registration_path
end

When /^I go to root page$/ do
  visit root_path
end

Then /^should this club be a pending club to me$/ do
  visit tournaments_path
  page.should have_content "Club Number 0"
  page.should_not have_content "Club Number 0 hinzufuegen"
end

Then /^user (\d+) should have one club$/ do |number|
  User.where(name: "User #{number}").first.clubs.count.should == 1
end

Then /^user (\d+) has no club$/ do |number|
  User.where(name: "User #{number}").first.clubs.count.should == 0
end

When /^I go to club '(\S+)'$/ do |club|
  club = Club.where(name: club).first
  visit clubs_path(club.id)
end