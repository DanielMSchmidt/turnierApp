class AddIndexes < ActiveRecord::Migration
  def up
    add_index :clubs, [:user_id]
    add_index :memberships, [:user_id]
    add_index :memberships, [:club_id]
    add_index :taggings, [:tagger_id, :tagger_type]
    add_index :tournaments, [:user_id]
  end

  def down
    remove_index :clubs, [:user_id]
    remove_index :memberships, [:user_id]
    remove_index :memberships, [:club_id]
    remove_index :taggings, [:tagger_id, :tagger_type]
    remove_index :tournaments, [:user_id]
  end
end
