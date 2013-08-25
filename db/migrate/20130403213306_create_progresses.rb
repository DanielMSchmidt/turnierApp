# -*- encoding : utf-8 -*-
class CreateProgresses < ActiveRecord::Migration
  def up
    create_table :progresses do |t|
      t.integer :couple_id
      t.string :kind
      t.integer :start_points
      t.integer :start_placings
      t.string :start_class
      t.boolean :finished

      t.timestamps
    end
  end
  def down
    drop_table :progresses
  end
end
