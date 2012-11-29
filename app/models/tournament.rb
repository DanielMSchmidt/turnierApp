class Tournament < ActiveRecord::Base
  default_scope order("date DESC")
  attr_accessible :number, :participants, :place, :user_id, :address, :date, :kind, :notes
  belongs_to :user

  validates :number, :participants, :place, presence: true, numericality: true

  def with_tag(tagname)
    tournaments = []
    User.tagged_with(tagname).each{ |user| tournaments += user.tournaments}
    tournaments.sort_by {|a| a[:created_at]} #later should be a thing like :date (after grabbing)
  end
end