class RemoveUsedFromBeacons < ActiveRecord::Migration
  def up
    remove_column :beacons, :used
      end

  def down
    add_column :beacons, :used, :boolean
  end
end
