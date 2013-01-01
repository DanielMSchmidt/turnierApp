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
    if (self.unenrolled_and_enrollable_tournaments_left_which_should_be_notified)
      NotificationMailer.enrollCouples(self.owner, self).deliver
      self.tournaments.each{|x| x.notification_send}
      puts "send weekly mail to #{self.name}"
    end
  end

  def unenrolled_and_enrollable_tournaments_left_which_should_be_notified
    return false if self.tournaments.nil?
    self.tournaments.collect{|x| x.should_send_a_notification_mail?}.include?(true)
  end
end
