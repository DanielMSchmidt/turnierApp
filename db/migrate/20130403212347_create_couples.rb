class CreateCouples < ActiveRecord::Migration
  def up
    create_table :couples do |t|
      t.integer :man_id
      t.integer :woman_id
      t.boolean :active

      t.timestamps
    end
  end
  def down
    drop_table :couples
  end
end
