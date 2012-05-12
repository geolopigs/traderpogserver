class CreateFlyerLocs < ActiveRecord::Migration
  def change
    create_table :flyer_locs do |t|
      t.string :locale
      t.string :localized_name
      t.string :localized_desc
      t.references :flyer_info

      t.timestamps
    end
    add_index :flyer_locs, :flyer_info_id
  end
end
