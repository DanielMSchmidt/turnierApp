# -*- encoding : utf-8 -*-
require 'rake'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  default_scope order('name ASC')
  after_create :notifyAboutNewUser
  after_create :buildEmptyCouple
  before_save :ensure_authentication_token

  delegate :startclass, to: :activeCouple

  # Hooks

  def self.sendUserNotification(newUser="Niemand")
    user = User.all
    logger.info "start sending usercount notification about #{user.count} couples"
    result = NotificationMailer.userCount(user, newUser).deliver
    logger.info "ended sending usercount notification: #{result}"
  end

  def notifyAboutNewUser
    logger.debug "notifying about new user #{self.name}"
    User.sendUserNotification(self.name)
  end

  def buildEmptyCouple
    Couple.createDummyCoupleFor(self)
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  # Accessors

  def tournaments
    unless self.activeCouple.nil?
      self.activeCouple.latin.tournaments + self.activeCouple.standard.tournaments
    else
      []
    end
  end

  def clubs
    self.getCouples.map{|c| c.clubs}.flatten.uniq
  end

  # access couples

  def getCouples
    Couple.includes(:clubs).all.select{|couple| couple.man_id == self.id || couple.woman_id == self.id}.uniq
  end

  def activeCouple
    couple = self.getCouples.select{|c| c.active}.first
    couple ||= buildEmptyCouple
    couple
  end

  def setPartner(man_id, woman_id)
    # Guards for authentication
    raise 'Not Authorized' and return unless (self.id == man_id) || (self.id == woman_id)

    old_couple = self.activeCouple
    old_couple.deactivate

    latin = old_couple.latin
    standard = old_couple.standard
    latin_class    = latin ? latin.start_class : 'D'
    standard_class = standard ? standard.start_class : 'D'
    new_couple     = Couple.new({man_id: man_id, woman_id: woman_id})

    #Add Progresses
    new_couple.progresses.new(start_class: latin_class, kind: 'latin')
    new_couple.progresses.new(start_class: standard_class, kind: 'standard')

    new_couple.save
  end

  def partner
    self.activeCouple.users.find { |u| u.id != self.id } || false
  end

  # find users

  def self.getIdByName(name)
    unless isntSet(name)
      user = User.where(name: name).first
      user.nil? ? nil : user.id
    else
      nil
    end
  end

  def self.findByName(name)
    id = User.getIdByName(name)
    return id unless id.nil?

    User.find(id)
  end

  def self.isntSet(parameter)
    parameter.nil? || parameter == 'Noch nicht eingetragen' || parameter == ''
  end

  def to_i
    self.id
  end

  def to_s
    "User: #{self.id} - #{self.email}"
  end

  def to_builder
    Jbuilder.new do |person|
      person.(self, :id, :name, :email)
    end
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
