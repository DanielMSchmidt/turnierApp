class CreateCouples < ActiveRecord::Migration
  def change
    create_table :couples do |t|
      t.integer :man_id
      t.integer :woman_id
      t.boolean :active

      t.timestamps
    end
  end
end
