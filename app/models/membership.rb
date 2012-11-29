class Membership < ActiveRecord::Base
  attr_accessible :club_id, :user_id
  belongs_to :user
  belongs_to :club
end
