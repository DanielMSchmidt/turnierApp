class Club < ActiveRecord::Base
  default_scope :order => 'name ASC'
  attr_accessible :name
  has_many :memberships
  has_many :users, :through => :memberships, :order => 'name ASC'
end
