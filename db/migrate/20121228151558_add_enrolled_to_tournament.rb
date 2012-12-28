class AddEnrolledToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :enrolled, :boolean, :default => true
  end
end
