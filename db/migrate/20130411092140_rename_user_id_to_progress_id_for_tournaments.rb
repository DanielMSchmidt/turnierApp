# -*- encoding : utf-8 -*-
class RenameUserIdToProgressIdForTournaments < ActiveRecord::Migration
  def up
    rename_column :tournaments, :user_id, :progress_id
  end

  def down
    rename_column :tournaments, :progress_id, :user_id
  end
end
