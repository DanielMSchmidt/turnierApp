# -*- encoding : utf-8 -*-
class Membership < ActiveRecord::Base
  attr_accessible :club_id, :couple_id, :verified, :trainer

  belongs_to :couple
  belongs_to :club

  scope :is_verified, where(verified: true)
  scope :is_unverified, where(verified: false)

  validates :couple_id, :club_id,  numericality: true, presence: true

  after_create :deleteOtherMembershipsForSameClub

  def user
    self.couple.users if self.couple
  end

  def self.verified?(club, couple)
    m = Membership.where(club_id: club, couple_id: couple).first
    !(m.nil? || !m.verified)
  end

  def self.coupleTrainsClub(club, couple)
    Membership.where(club_id: club, couple_id: couple, trainer: true).any?
  end

  def deleteOtherMembershipsForSameClub
    Membership.where(club_id: self.club_id, couple_id: self.couple_id).reject{|x| x.id == self.id}.each{|m| m.delete}
  end
end
