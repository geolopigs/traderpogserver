class AddDisabledToFlyerInfos < ActiveRecord::Migration
  def change
    add_column :flyer_infos, :disabled, :boolean

  end
end
