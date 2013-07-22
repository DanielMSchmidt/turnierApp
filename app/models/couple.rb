# -*- encoding : utf-8 -*-
class Couple < ActiveRecord::Base
  attr_accessible :active, :man_id, :woman_id
  default_scope includes(:man, :woman)

  belongs_to :man, :class_name => "User"
  belongs_to :woman, :class_name => "User"

  has_many :memberships, :dependent => :destroy
  has_many :clubs, :through => :memberships
  has_many :progresses

  before_save :set_initial_values
  after_create :deactivate_other_couples
  after_create :build_progresses

  #Initialize
  def set_initial_values
    self.active = true if self.active.nil?
  end

  #Activation
  def deactivate_other_couples
    couples = Couple.where(man_id: self.man_id) + Couple.where(woman_id: self.woman_id)
    couples.each{|couple| couple.deactivate unless couple == self}
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

  # Progresses
  def standard
    self.progresses.active.standard.first
  end

  def latin
    self.progresses.active.latin.first
  end

  def build_progresses
    self.progresses.create(kind: 'latin') if self.latin.nil?
    self.progresses.create(kind: 'standard') if self.standard.nil?
  end

  # Accessors

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

  def tournaments
    self.latin.tournaments + self.standard.tournaments
  end

  def to_s
    "#{self.getWoman.name} / #{self.getMan.name}"
  end
end
