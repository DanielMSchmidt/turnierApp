class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  default_scope :order => 'name ASC'

  has_many :tournaments
  has_many :memberships
  has_many :clubs, :through => :memberships

  def organises(tournament)
    tournament.user.clubs.each do |club|
      return true if club.owner == self
    end
    false
  end
end
