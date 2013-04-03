class Couple < ActiveRecord::Base
  attr_accessible :active, :man_id, :woman_id
  belongs_to :man, :class_name => "User"
  belongs_to :woman, :class_name => "User"
end
