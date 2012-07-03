class AddFbidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fbid, :string
    add_index :users, :fbid
  end
end
