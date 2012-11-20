class Tournament < ActiveRecord::Base
  attr_accessible :number, :participants, :place, :user_id
  belongs_to :user
  def with_tag(tagname)
    tournaments = []
    User.tagged_with(tagname).each{ |user| tournaments += user.tournaments}
    tournaments.sort_by {|a| a[:created_at]} #later should be a thing like :date (after grabbing)
  end
end
