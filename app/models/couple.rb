class Couple < ActiveRecord::Base
  attr_accessible :active, :man_id, :woman_id
  default_scope includes(:man, :woman)

  belongs_to :man, :class_name => "User"
  belongs_to :woman, :class_name => "User"
  has_many :progresses

  before_save :set_initial_values
  before_create :deactivate_other_couples
  after_create :build_progresses

  #initialize

  def set_initial_values
    self.active = true if self.active.nil?
  end


  #Activation

  def deactivate_other_couples
    couples = Couple.where(man_id: self.man_id) + Couple.where(woman_id: self.woman_id)
    couples.each{|couple| couple.deactivate}
  end

  def activate
    self.active = true
    self.save
  end

  def deactivate
    self.active = false
    self.save
  end

  # Progresses

  def standard
    self.progresses.active.standard.first
  end

  def latin
    self.progresses.active.latin.first
  end

  def build_progresses
    self.progresses.create(kind: 'latin') if self.latin.nil?
    self.progresses.create(kind: 'standard') if self.standard.nil?
  end

  # Users
  def users
    [self.man, self.woman]
  end

end