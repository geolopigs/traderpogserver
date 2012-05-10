class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.integer :userid
      t.float :longitude
      t.float :latitude
      t.string :img
      t.integer :region

      t.timestamps
    end
  end
end
