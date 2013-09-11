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

  def self.sendUserNotification(newUser)
    user = User.all
    logger.info "start sending usercount notification about #{user.count} couples"
    NotificationMailer.userCount(user, newUser).deliver
    logger.info "ended sending usercount notification"
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
    self.getCouples.select{|couple| couple.active}.first
  end

  # find users

  def self.getIdByName(name)
    unless isntSet(name)
      user = User.where(name: name).first
      if user.nil?
        nil
      else
        user.id
      end
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
