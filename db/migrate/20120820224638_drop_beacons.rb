class DropBeacons < ActiveRecord::Migration
  def up
    drop_table :beacons
  end

  def down
    create_table :beacons do |t|
      t.datetime :expiration
      t.string :fbid
      t.references :user
      t.references :post

      t.timestamps
    end
    add_index :beacons, :user_id
    add_index :beacons, :post_id
  end
end
