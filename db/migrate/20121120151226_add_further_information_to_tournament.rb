# -*- encoding : utf-8 -*-
class AddFurtherInformationToTournament < ActiveRecord::Migration
  def change
	add_column :tournaments, :address, :string
	add_column :tournaments, :date, :datetime
	add_column :tournaments, :kind, :string
	add_column :tournaments, :notes, :string
  end
end
