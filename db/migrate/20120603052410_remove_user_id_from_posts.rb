class RemoveUserIdFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :userid
      end

  def down
    add_column :posts, :userid, :integer
  end
end
