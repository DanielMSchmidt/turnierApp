# -*- encoding : utf-8 -*-
class AddUserToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :user_id, :integer
  end
end
