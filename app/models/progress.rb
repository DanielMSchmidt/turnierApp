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
    self.start_class = 'D' if start_class.nil? || start_class == ''
    self.start_placings ||= 0
    self.start_points ||= 0
  end

  def levelUp
    finishAndSetStartClass(self.nextClass)
  end

  def reset
    finishAndSetStartClass(self.start_class)
  end

  def finishAndSetStartClass(start_class)
    self.finished = true
    self.save
    Progress.create(couple_id: self.couple_id, start_class: start_class, kind: self.kind)
  end

  def maxPointsOfClass
    case self.start_class
      when 'D'
        100
      when 'C'
        150
      when 'B'
        200
      else
        250
    end
  end

  def maxPlacingsOfClass
    case self.start_class
      when 'D'
        7
      when 'C'
        7
      when 'B'
        7
      else
        10
    end
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

  # Finders
  def danced_tournaments
    self.tournaments.reject{|tournament| tournament.upcoming?}
  end

  # Points & Placings
  def points
    self.start_points + (self.tournaments.collect{|tournament| tournament.points}.inject(:+) || 0)
  end

  def placings
    self.start_placings + (self.tournaments.collect{|tournament| tournament.placing}.inject(:+) || 0)
  end

  def points_at_time(time)
    get_tournaments_before(time).collect{|tournament| tournament.points}.inject(:+)
  end

  def placings_at_time(time)
    get_tournaments_before(time).collect{|tournament| tournament.placing}.inject(:+)
  end

  def get_tournaments_before(time)
    self.tournaments.select{|tournament| tournament.date <= time}
  end

  def points_in_percentage
    percentage = (self.points * 100) / maxPointsOfClass.to_f
    (percentage > 100) ? 100 : percentage.round(2)
  end

  def placings_in_percentage
    percentage = (self.placings * 100) / maxPlacingsOfClass.to_f
    (percentage > 100) ? 100 : percentage.round(2)
  end
end