class AddFurtherInformationToTournament < ActiveRecord::Migration
  def change
	add_column :tournaments, :address, :string
	add_column :tournaments, :date, :string
	add_column :tournaments, :time, :string
	add_column :tournaments, :kind, :string
	add_column :tournaments, :notes, :string
  end
end
