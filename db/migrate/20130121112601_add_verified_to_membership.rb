class AddVerifiedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :verified, :boolean, default: true
  end
end
