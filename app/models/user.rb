require 'rake'
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  default_scope :order => 'name ASC'
  after_create :notify_about_new_user

  has_many :tournaments
  has_many :memberships
  has_many :clubs, :through => :memberships

  def organises(tournament)
    tournament.user.clubs.each do |club|
      return true if club.owner == self
    end
    false
  end

  def notify_about_new_user
    logger.debug "notifying about new user #{self.name}"
    User.send_user_notification(self.name)
  end

  def self.send_user_notification(newUser)
    user = User.all
    puts "start sending usercount notification about #{user.count} couples"
    NotificationMailer.userCount(user, newUser).deliver
    puts "ended sending usercount notification"
  end
end
