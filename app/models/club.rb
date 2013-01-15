class Club < ActiveRecord::Base
  require 'celluloid'

  default_scope :order => 'name ASC'
  attr_accessible :name
  belongs_to :user
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships, :order => 'name ASC'
  validates :name, presence: true, :uniqueness => true

  def owner
    if self.user_id.nil?
      nil
    else
      self.user
    end
  end

  def is_owner?(user)
    self.user_id == user.id
  end

  def transfer_to(new_user)
    self.user_id = new_user.id
    self.save!
  end

  def tournaments
    return nil if self.user.nil? || self.user.tournaments.nil?
    self.user.tournaments
  end

  def mail_owner_unenrolled_tournaments
    if (self.unenrolled_and_enrollable_tournaments_left_which_should_be_notified)
      NotificationMailer.enrollCouples(self.owner, self).deliver
      self.tournaments.each{|x| x.notification_send}
      logger.debug "send weekly mail to #{self.name} at mail #{self.owner.email}"
    end
    logger.debug "did not send weekly mail to #{self.name}"
  end

  def unenrolled_and_enrollable_tournaments_left_which_should_be_notified
    return false if self.tournaments.nil?
    self.tournaments.collect{|x| x.should_send_a_notification_mail?}.include?(true)
  end
end
