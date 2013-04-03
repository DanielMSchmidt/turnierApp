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
    date (DateTime.now.to_date + 2.weeks).to_date
    kind 'HGR C LAT'
    enrolled false
  end

  factory :d_class_tournament do
    number 27114
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    enrolled false
  end

  factory :c_class_tournament do
    number 27115
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    enrolled false
  end

  factory :b_class_tournament do
    number 28044
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    enrolled false
  end

  factory :future_tournament do
    number 29239
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
    enrolled true
  end

  factory :membership do
    club_id 1
    user_id 1
  end

  factory :couple do
    man_id 1
    woman_id 2
    active true
  end

  factory :progress do
    couple_id 1
    kind "latin"
    start_points 0
    start_placings 0
    start_class 'C'
    finished false
  end
end