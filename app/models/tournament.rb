class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  default_scope includes(:user)
  attr_accessible :number, :participants, :place, :user_id, :address, :date, :kind, :notes, :enrolled
  belongs_to :user

  validates :number, presence: true, numericality: true
  validate :no_double_tournaments_are_allowed

  before_save do
    self.fillup_missing_data
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
      self.enrolled = false
    else
      self.enrolled = true
      self.participants ||= self.place
      self.place ||= self.participants
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
end