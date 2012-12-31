class Club < ActiveRecord::Base
  default_scope :order => 'name ASC'
  attr_accessible :name
  belongs_to :user
  has_many :memberships
  has_many :users, :through => :memberships, :order => 'name ASC'
  validates :name, presence: true, :uniqueness => true

  def owner
    if self.user_id.nil?
      nil
    else
      self.user
    end
  end

  def tournaments
    return nil if self.user.nil? || self.user.tournaments.nil?
    self.user.tournaments
  end

  def mail_owner_unenrolled_tournaments
    if (self.unenrolled_and_enrollable_tournaments_left)
      NotificationMailer.enrollCouples(self.owner, self).deliver
      puts "send weekly mail to #{self.name}"
    end
  end

  def unenrolled_and_enrollable_tournaments_left
    return false if self.tournaments.nil?
    self.tournaments.collect{|x| !x.enrolled? && x.date.to_date < Date.today + 5.weeks}.include?(true)
  end
end
