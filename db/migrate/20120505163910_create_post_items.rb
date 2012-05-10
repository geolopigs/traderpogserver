class CreatePostItems < ActiveRecord::Migration
  def change
    create_table :post_items do |t|
      t.references :post
      t.references :item_info
      t.integer :level

      t.timestamps
    end
    add_index :post_items, :post_id
    add_index :post_items, :item_info_id
  end
end
