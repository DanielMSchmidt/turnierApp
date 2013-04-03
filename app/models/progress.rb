class Progress < ActiveRecord::Base
  attr_accessible :couple_id, :finished, :kind, :start_class, :start_placings, :start_points
end
