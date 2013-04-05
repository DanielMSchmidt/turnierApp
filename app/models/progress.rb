class Progress < ActiveRecord::Base
  attr_accessible :couple_id, :finished, :kind, :start_class, :start_placings, :start_points
  scope :active, lambda { where(finished: false) }
  scope :latin, lambda { where(kind: 'latin') }
  scope :standard, lambda { where(kind: 'standard') }

  belongs_to :couple
  has_many :tournaments

  validates :kind, presence: true, :inclusion=> { :in => ['latin', 'standard'] }

  before_save :set_initial_values

  #initialisation

  def set_initial_values
    self.finished ||= false
    self.start_class ||= 'D'
    self.start_placings ||= 0
    self.start_points ||= 0
  end

  def placings
    self.start_placings + self.tournaments.collect{|tournament| tournament.placing}.inject(:+)
  end

  def points
    self.start_points + self.tournaments.collect{|tournament| tournament.points}.inject(:+)
  end
end