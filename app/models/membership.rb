# -*- encoding : utf-8 -*-
class Membership < ActiveRecord::Base
  attr_accessible :club_id, :couple_id, :verified

  belongs_to :couple
  belongs_to :club

  scope :is_verified, where(verified: true)
  scope :is_unverified, where(verified: false)

  validates :couple_id, :club_id,  numericality: true, presence: true

  def user
    self.couple.users if self.couple
  end

  def self.verified?(club, couple)
    m = Membership.where(club_id: club, couple_id: couple).first
    if m.nil? || !m.verified
      false
    else
      true
    end
  end
end
