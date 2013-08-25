class ChangeuserToCoupleForMemebership < ActiveRecord::Migration
  def up
    rename_column :memberships, :user_id, :couple_id
  end

  def down
    rename_column :memberships, :couple_id, :user_id
  end
end
