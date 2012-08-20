class AddBeacontimeToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :beacontime, :datetime

  end
end
