class Progress < ActiveRecord::Base
  attr_accessible :couple_id, :finished, :kind, :start_class, :start_placings, :start_points
  scope :active, lambda { where(finished: false) }
  scope :latin, lambda { where(kind: 'latin') }
  scope :standard, lambda { where(kind: 'standard') }

  validates :kind, presence: true

  before_save :set_initial_values

  def set_initial_values
    self.finished ||= false
    self.start_class ||= 'D'
    self.start_placings ||= 0
    self.start_points ||= 0
  end
end