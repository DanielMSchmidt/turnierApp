class Couple < ActiveRecord::Base
  attr_accessible :active, :man_id, :woman_id
  belongs_to :man, :class_name => "User"
  belongs_to :woman, :class_name => "User"

  after_create :deactivate_other_couples

  def deactivate_other_couples
    Couple.where(man_id: self.man_id, active: true).each{|couple| couple.deactivate}
    Couple.where(woman_id: self.woman_id, active: true).each{|couple| couple.deactivate}
  end


  def activate
    self.active = true
    self.save
  end

  def deactivate
    self.active = false
    self.save
  end
end
