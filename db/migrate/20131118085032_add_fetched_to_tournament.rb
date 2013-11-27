class AddFetchedToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :fetched, :boolean, :default => false
  end
end
