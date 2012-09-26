class AddFbNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_name, :string

  end
end
