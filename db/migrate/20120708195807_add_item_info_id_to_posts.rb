class AddItemInfoIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :item_info_id, :integer
  end
end
