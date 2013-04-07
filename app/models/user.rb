require 'rake'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  default_scope :order => 'name ASC'
  after_create :notify_about_new_user

  has_many :tournaments
  has_many :memberships, :dependent => :destroy
  has_many :clubs, :through => :memberships
  has_many :couples

  def self.send_user_notification(newUser)
    user = User.all
    logger.info "start sending usercount notification about #{user.count} couples"
    NotificationMailer.userCount(user, newUser).deliver
    logger.info "ended sending usercount notification"
  end

  def notify_about_new_user
    logger.debug "notifying about new user #{self.name}"
    User.send_user_notification(self.name)
  end

  def getOrganisedTournaments
    logger.debug "setting organised tournaments for user #{self.id}"
    clubs = Club.where(user_id: self.id)

    unless clubs.empty?
      logger.debug "found clubs: #{clubs.collect{|x| x.name}.join(", ")}"
      return clubs.collect{|x| x.tournaments}.flatten
    else
      logger.debug "no club found"
      return []
    end
  end

  def get_couples
    Couple.all.select{|couple| couple.man_id == self.id || couple.woman_id == self.id}.uniq
  end

  def activeCouple
    self.get_couples.select{|couple| couple.active}.first
  end

  def verified_clubs
    self.memberships.is_verified.collect{|x| x.club}.compact.uniq
  end

  def unverified_clubs
    self.memberships.includes(:club).is_unverified.collect{|x| x.club}.compact.uniq
  end

  def to_i
    self.id
  end

  def to_s
    "User: #{self.id} - #{self.email}"
  end
end