class AddTrainerFlagToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :trainer, :boolean, default: false
  end
end
