#encoding: utf-8
class Club < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships, order: 'name ASC'
  validates :name, presence: true, uniqueness: true
  default_scope order: 'name ASC'

  def owner
    if self.user_id.nil?
      nil
    else
      self.user
    end
  end

  def is_owner?(user)
    return false if user.nil?
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
    logger.debug "Moved mail owner unenrolled tournaments to Worker for #{self.name}"
    MailUnenrolledTournamentsWorker.perform_async(self)
  end

  def unenrolled_and_enrollable_tournaments_left_which_should_be_notified
    return false if self.tournaments.nil?
    self.tournaments.collect{|x| x.should_send_a_notification_mail?}.include?(true)
  end

  def verified_members
    self.memberships.is_verified.collect{|x| x.user}
  end

  def unverified_members
    self.memberships.is_unverified.collect{|x| x.user}
  end

  def is_verified_member(user)
    self.verified_members.include?(user)
  end

  def to_s
    self.name
  end

  def to_i
    self.id
  end
end
