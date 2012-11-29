class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  attr_accessible :number, :participants, :place, :user_id, :address, :date, :kind, :notes
  belongs_to :user

  validates :number, :participants, :place, presence: true, numericality: true
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
end