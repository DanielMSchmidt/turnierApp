# -*- encoding : utf-8 -*-
class Club < ActiveRecord::Base
  attr_accessible :name, :user_id
  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :couples, through: :memberships
  validates :name, presence: true, uniqueness: true
  default_scope order: 'name ASC'


  def self.ownedBy(current_user_id)
    Club.where(user_id: current_user_id)
  end

  def self.trainedBy(current_user_id)
    coupleId = User.find(current_user_id).activeCouple.id
    Club.all.select{|c| Membership.coupleTrainsClub(c.id, coupleId)}
  end

  def is_owner(user)
    self.owner ? (self.owner.id == user.id) : false
  end

  def owner
    if self.user_id.nil?
      nil
    else
      self.user
    end
  end

  def transferTo(new_user)
    self.user_id = new_user.id
    self.save!
  end

  def tournaments
    return nil if self.user.nil? || self.user.tournaments.nil?
    self.couples.collect{|couple| couple.tournaments}.flatten
  end

  def mailOwnerOfUnenrolledTournaments
    logger.debug "Moved mail owner unenrolled tournaments to Worker for #{self.name}"
    if (self.unenrolledAndEnrollableTournamentsLeftWhichShouldBeNotified)
      NotificationMailer.enrollCouples(self.owner, self).deliver
      self.tournaments.each{|x| x.notificationSend}
      logger.debug "send weekly mail to #{self.name} at mail #{self.owner.email}"
    else
      logger.debug "did not send weekly mail to #{self.name}"
    end
  end

  def unenrolledTournaments
    self.tournaments.select{|t| !t.enrolled?}
  end

  def unenrolledAndEnrollableTournamentsLeftWhichShouldBeNotified
    return false if self.tournaments.nil?
    self.tournaments.collect{|x| x.shouldSendANotificationMail?}.include?(true)
  end

  def resultsForTime(from, to)
    tournaments = self.tournaments
    points = tournaments.collect{|t| t.points}.inject(:+)
    placings = tournaments.collect{|t| t.placing}.inject(:+)
    {points: points, placings: placings}
  end

  # Verified couples & users

  def verifiedCouples(active=true)
    self.memberships.is_verified.includes(:couple).collect{|m| m.couple}.select{|c| c.active == active}.uniq
  end

  def unverifiedCouples(active=true)
    self.memberships.is_unverified.includes(:couple).collect{|m| m.couple}.select{|c| c.active == active}.uniq
  end

  def verifiedUsers
    self.verifiedCouples.collect{|u| u.users}.flatten
  end

  def unverifiedUsers
    self.unverifiedCouples.collect{|u| u.users}.flatten
  end

  def isVerifiedUser(user)
    self.verifiedUsers.include?(user)
  end

  def isUnverifiedUser(user)
    self.unverifiedUsers.include?(user)
  end

  def to_s
    self.name
  end

  def to_i
    self.id
  end
end
