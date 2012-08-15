class AddFbidToBeacons < ActiveRecord::Migration
  def change
    add_column :beacons, :fbid, :string
    add_index :beacons, :fbid
  end
end
