#encoding: utf-8
class Membership < ActiveRecord::Base
  attr_accessible :club_id, :user_id, :verified
  belongs_to :user
  belongs_to :club

  scope :is_verified, where(verified: true)
  scope :is_unverified, where(verified: false)
end
