class CreateFlyerPaths < ActiveRecord::Migration
  def change
    create_table :flyer_paths do |t|
      t.references :user_flyer
      t.integer :post1
      t.integer :post2
      t.float :longitude1
      t.float :latitude1
      t.float :longitude2
      t.float :latitude2
      t.integer :storms
      t.integer :stormed

      t.timestamps
    end
    add_index :flyer_paths, :user_flyer_id
  end
end
