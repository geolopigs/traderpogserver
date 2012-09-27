class AddLoadTimeToFlyerInfos < ActiveRecord::Migration
  def change
    add_column :flyer_infos, :load_time, :integer

  end
end
