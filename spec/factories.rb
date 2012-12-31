require 'factory_girl'

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'test@testuser.de'
    password 'testtest12345'
    password_confirmation 'testtest12345'
    remember_me true
  end

  factory :club do
    name 'Example Club'
    user_id 1
  end

  factory :tournament do
    number 28288
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    enrolled false
  end

  factory :enrolled_tournament, class: Tournament do
    number 28289
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    participants 12
    place 3
  end

  factory :membership do
    club_id 1
    user_id 1
  end
end