class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  attr_accessible :number, :participants, :place, :user_id, :address, :date, :kind, :notes, :enrolled
  belongs_to :user

  validates :number, presence: true, numericality: true
  validate :no_double_tournaments_are_allowed

   def no_double_tournaments_are_allowed
     puts Tournament.where(:number => number, :user_id => user_id).size == 0
     errors.add(:double, "was allready added") unless Tournament.where(:number => number, :user_id => user_id).size == 0
   end

  def with_tag(tagname)
    tournaments = []
    User.tagged_with(tagname).each{ |user| tournaments += user.tournaments}
    tournaments.sort_by {|a| a[:created_at]} #later should be a thing like :date (after grabbing)
  end

  def upcoming?
    return self.participants.nil? && self.place.nil?
  end

  def fillup_missing_data
    #if particiants or place is given and it's not upcoming, set place or particiants to default value
    unless (self.upcoming?)
      self.participants ||= self.place
      self.place ||= self.participants
    end
    self #for chaining
  end

  def behind_time?
    #true if its upcoming and it has been danced jet
    self.upcoming? && (self.date.to_datetime < Time.now)
  end
end