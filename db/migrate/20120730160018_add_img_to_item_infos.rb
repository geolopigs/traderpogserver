class AddImgToItemInfos < ActiveRecord::Migration
  def change
    add_column :item_infos, :img, :string
    add_column :item_infos, :disabled, :boolean

  end
end
