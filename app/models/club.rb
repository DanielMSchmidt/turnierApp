class Club < ActiveRecord::Base
  default_scope :order => 'name ASC'
  attr_accessible :name, :user_id
  belongs_to :user
  has_many :memberships
  has_many :users, :through => :memberships, :order => 'name ASC'
  validates :name, presence: true, :uniqueness => true

  def owner
    if self.user_id.nil?
      nil
    else
      self.user
    end
  end
end
