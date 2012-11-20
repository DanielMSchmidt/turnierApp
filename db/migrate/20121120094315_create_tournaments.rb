class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.integer :number
      t.integer :user_id
      t.integer :place
      t.integer :participants

      t.timestamps
    end
  end
end
