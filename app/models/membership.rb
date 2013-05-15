# -*- encoding : utf-8 -*-
class Membership < ActiveRecord::Base
  attr_accessible :club_id, :couple_id, :verified
  belongs_to :couple
  belongs_to :club

  default_scope includes(:couple)
  scope :is_verified, where(verified: true)
  scope :is_unverified, where(verified: false)

  def user
    if self.couple.nil?
      []
    else
      self.couple.users
    end
  end
end
