class Progress < ActiveRecord::Base
  attr_accessible :couple_id, :finished, :kind, :start_class, :start_placings, :start_points
  scope :active, lambda { where(finished: false) }
  scope :latin, lambda { where(kind: 'latin') }
  scope :standard, lambda { where(kind: 'standard') }

  before_save :set_initial_values

  belongs_to :couple
  has_many :tournaments

  validates :kind, presence: true, :inclusion=> { :in => ['latin', 'standard'] }


  #initialisation

  def set_initial_values
    self.finished = false if self.finished.nil?
    self.start_class ||= 'D'
    self.start_placings ||= 0
    self.start_points ||= 0
  end

  def finish
    self.finished = true
    self.save
  end

  # TODO: Dry up
  def levelUp
    self.finish
    Progress.create(couple_id: self.couple_id, start_class: self.nextClass, kind: self.kind)
  end

  def reset
    self.finish
    Progress.create(couple_id: self.couple_id, start_class: self.start_class, kind: self.kind)
  end

  def nextClass
    case self.start_class
      when 'D'
        'C'
      when 'C'
        'B'
      when 'B'
        'A'
      else
        'S'
    end
  end

  def placings
    self.start_placings + self.tournaments.collect{|tournament| tournament.placing}.inject(:+)
  end

  def points
    self.start_points + self.tournaments.collect{|tournament| tournament.points}.inject(:+)
  end
end