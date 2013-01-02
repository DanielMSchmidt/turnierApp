class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  default_scope includes(:user)
  attr_accessible :number, :participants, :place, :user_id, :address, :date, :kind, :notes, :enrolled, :notificated_about
  belongs_to :user

  validates :number, presence: true, numericality: true
  validate :no_double_tournaments_are_allowed

  before_save do
    self.fillup_missing_data
  end

  def to_s
    "Tournament ##{self.id} - date: #{self.date} - enrolled: #{self.enrolled} - notificated_about: #{self.notificated_about}"
  end

   def no_double_tournaments_are_allowed
     Tournament.where(:number => number, :user_id => user_id).size == 0
     errors.add(:double, "was allready added") unless Tournament.where(:number => number, :user_id => user_id).size == 0
   end

  def upcoming?
    return self.participants.nil? && self.place.nil?
  end

  def fillup_missing_data
    #if particiants or place is given and it's not upcoming, set place or particiants to default value
    #set enrolled to false if it is upcoming
    if (self.upcoming?)
      logger.debug "detected an upcoming tournament - #{self.to_s}"
      self.enrolled = false
    else
      logger.debug "filling up missing data for #{self.to_s}"
      self.enrolled = true
      self.participants ||= self.place
      self.place ||= self.participants
      logger.debug "filled up as #{self.to_s}"
    end
    self #for chaining
  end

  def behind_time?
    #true if its upcoming and it has been danced jet
    self.upcoming? && (self.date.to_datetime < Time.now)
  end

  def got_placing?
    return false if self.upcoming?

    place_for_placing = 3
    place_for_placing = 5 if self.start_class == 'C'
    place_for_placing = 6 if self.start_class == 'D'

    return (self.place <= place_for_placing) && (self.points >= 2)
  end

  def points
    participants = self.participants ||= 0
    place = self.place ||= 0
    [(participants - place), 20].min
  end

  def start_class
    return self.kind.split(" ")[1]
  end

  def should_send_a_notification_mail?
    logger.debug "test if a notification mail should be sended about #{self.to_s}"
    return false if self.enrolled? || !(Date.today..(Date.today + 5.weeks)).include?(self.date.to_date)
    if !(((Date.today - 2.weeks)..Date.today).include?(self.notificated_about.to_date) unless self.notificated_about.nil?)
      logger.debug "a notification mail should be send about #{self.to_s}"
      return true
    end
  end

  def notification_send
    self.notificated_about = Date.today
    self.save
    logger.debug "the notification was send for #{self.to_s} and the time was updated"
  end
end