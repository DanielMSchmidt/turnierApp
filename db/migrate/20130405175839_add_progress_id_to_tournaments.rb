# -*- encoding : utf-8 -*-
class AddProgressIdToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :progress_id, :integer
  end
end
