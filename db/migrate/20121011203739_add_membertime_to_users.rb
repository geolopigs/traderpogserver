class AddMembertimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :membertime, :datetime

  end
end
