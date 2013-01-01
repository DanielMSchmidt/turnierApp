class AddNotificatedAboutTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :notificated_about, :date
  end
end
