class AddFbFriendsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_friends, :string

  end
end
