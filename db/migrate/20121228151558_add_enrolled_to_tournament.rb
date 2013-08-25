# -*- encoding : utf-8 -*-
class AddEnrolledToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :enrolled, :boolean, :default => true
  end
end
