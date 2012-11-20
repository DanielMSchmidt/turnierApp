class Tournament < ActiveRecord::Base
  attr_accessible :number, :participants, :place, :user_id
end
