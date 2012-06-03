class CreateBeacons < ActiveRecord::Migration
  def change
    create_table :beacons do |t|
      t.boolean :used
      t.datetime :expiration
      t.references :user
      t.references :post

      t.timestamps
    end
    add_index :beacons, :user_id
    add_index :beacons, :post_id
  end
end
