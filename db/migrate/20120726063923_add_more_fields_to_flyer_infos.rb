class AddMoreFieldsToFlyerInfos < ActiveRecord::Migration
  def change
    add_column :flyer_infos, :price, :integer
    add_column :flyer_infos, :tier, :integer
  end
end
