class AddInventoryToUserFlyers < ActiveRecord::Migration
  def change
    add_column :user_flyers, :item_info_id, :integer

    add_column :user_flyers, :num_items, :integer

    add_column :user_flyers, :cost_basis, :float

  end
end
