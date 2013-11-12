# -*- encoding : utf-8 -*-
require 'rake'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  default_scope order('name ASC')
  after_create :notifyAboutNewUser
  after_create :buildEmptyCouple

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
    Couple.create(man_id: self.id, active: true)
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
    couple = self.getCouples.select{|couple| couple.active}.first
    if couple.nil?
      Couple.create(man_id: self.id, active: true)
      couple = Couple.where(man_id: self.id, active: true).first
    end
    couple
  end

  # ability check
  def isAllowedTo(permission)
    # TODO: Fill me [permission is hash {manage: club.id}] (manage club / edit couple / is trainer / is admin / can see his tournaments[has a couple])
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

  def self.isntSet(parameter)
    parameter.nil? || parameter == 'Noch nicht eingetragen' || parameter == ''
  end

  def to_i
    self.id
  end

  def to_s
    "User: #{self.id} - #{self.email}"
  end
end
