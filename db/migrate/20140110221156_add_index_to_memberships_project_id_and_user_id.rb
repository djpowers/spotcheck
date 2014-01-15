class AddIndexToMembershipsProjectIdAndUserId < ActiveRecord::Migration
  def up
    add_index :memberships, [:project_id, :user_id], unique: true
  end
  def down
    remove_index :memberships, [:project_id, :user_id]
  end
end
