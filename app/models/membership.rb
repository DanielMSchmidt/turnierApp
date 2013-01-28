class Membership < ActiveRecord::Base
  attr_accessible :club_id, :user_id, :verified
  belongs_to :user
  belongs_to :club

  scope :verified, where(verified: true)
  scope :unverified, where(verified: false)
end
