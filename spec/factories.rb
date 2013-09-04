# -*- encoding : utf-8 -*-
require 'factory_girl'

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'test@testuser.de'
    password 'testtest12345'
    initialize_with { User.find_or_create_by_email('test@testuser.de') }
  end

  factory :club do
    name 'Example Club'
    user_id 1
    initialize_with { Club.find_or_create_by_name('Example Club') }
  end

  factory :other_club, class: Club do
    name 'Second Example Club'
    user_id 2
    initialize_with { Club.find_or_create_by_name('Second Example Club') }
  end

  factory :tournament do
    ignore do
      number 28288
      progress_id 1
      data {{number: number, progress_id: progress_id, address: 'testaddress', date: (DateTime.now.beginning_of_day.to_date + 2.weeks), kind: 'HGR C LAT', enrolled: false}}
    end
    initialize_with { Tournament.where(number: number, progress_id: progress_id).first || Tournament.create(data) }
  end


  factory :d_class_tournament, class: Tournament do
    number 27114
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    enrolled false
  end

  factory :c_class_tournament, class: Tournament do
    number 27115
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    enrolled false
  end

  factory :b_class_tournament, class: Tournament do
    number 28044
    user_id 1
    address 'testaddress'
    date (DateTime.now + 2.weeks).to_date
    enrolled false
  end

  factory :future_tournament, class: Tournament do
    number 29239
    progress_id 1
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
    couple_id 1
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
