# -*- encoding : utf-8 -*-
class Couple < ActiveRecord::Base
  attr_accessible :active, :man_id, :woman_id
  default_scope includes(:man, :woman)

  belongs_to :man, :class_name => "User"
  belongs_to :woman, :class_name => "User"

  has_many :memberships, :dependent => :destroy
  has_many :clubs, :through => :memberships
  has_many :progresses

  before_save :setInitialValues
  after_create :deactivateOtherCouples
  after_create :buildProgresses

  validate :dontDanceWithYourself

  def dontDanceWithYourself
    if self.man_id == self.woman_id
      errors.add(:man_id, "Du kannst nicht mit dir selbst tanzen")
      errors.add(:woman_id, "Du kannst nicht mit dir selbst tanzen")
    end
  end

  # Finder
  def self.containingIds(ids)
    (Couple.where(man_id: ids) + Couple.where(woman_id: ids)).uniq
  end

  # Initialize
  def setInitialValues
    clubs = self.users.map{|u| u.clubs }.flatten
    self.setClubs(clubs)
    self.active = true if self.active.nil?
  end

  # Activation
  def deactivateOtherCouples
    Couple.containingIds(self.userIds).each do |couple|
      couple.deactivate unless couple == self
    end
  end

  def activate
    self.active = true
    self.save
  end

  def deactivate
    self.active = false
    self.save
  end

  # Validation
  def consistsOfCurrentUser(user)
    user.id == self.man_id || user.id == self.woman_id
  end

  # Setter
  def setClubs(clubs)
    clubs.each do |club|
      Membership.create(couple_id: self.id, club_id: club.id, verified: Membership.verified?(club, self))
    end
  end

  # Progresses
  def standard
    self.progresses.active.standard.first
  end

  def latin
    self.progresses.active.latin.first
  end

  def buildProgresses
    self.progresses.create(kind: 'latin') if self.latin.nil?
    self.progresses.create(kind: 'standard') if self.standard.nil?
  end

  # Accessors

  def trainer?(club_id)
    Membership.coupleTrainsClub(club_id, self.id)
  end

  def isComplete?
    self.users.count == 2
  end

  def getMan
    if self.man.nil?
      User.new(name: 'Noch nicht eingetragen')
    else
      self.man
    end
  end

  def getWoman
    if self.woman.nil?
      User.new(name: 'Noch nicht eingetragen')
    else
      self.woman
    end
  end

  def users
    [self.getMan, self.getWoman].reject{|user| user.id.nil?}
  end

  def userIds
    self.users.collect{|u| u.id}
  end

  def tournaments
    self.latin.tournaments + self.standard.tournaments
  end

  def to_s
    "#{self.getWoman.name} & #{self.getMan.name}"
  end

  def to_s_two_lines
    "#{self.getWoman.name} <br> #{self.getMan.name}"
  end
end
