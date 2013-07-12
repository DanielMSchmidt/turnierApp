# -*- encoding : utf-8 -*-
class Membership < ActiveRecord::Base
  attr_accessible :club_id, :couple_id, :verified
  belongs_to :coulpe, :foreign_key =>:coulpe_id
  belongs_to :club, :foreign_key =>:club_id

  scope :is_verified, where(verified: true)
  scope :is_unverified, where(verified: false)

end
