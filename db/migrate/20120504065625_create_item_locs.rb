class CreateItemLocs < ActiveRecord::Migration
  def change
    create_table :item_locs do |t|
      t.string :locale
      t.string :localized_name
      t.string :localized_desc
      t.references :item_info

      t.timestamps
    end
    add_index :item_locs, :item_info_id
  end
end
