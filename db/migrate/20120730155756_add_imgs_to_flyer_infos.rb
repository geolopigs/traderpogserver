class AddImgsToFlyerInfos < ActiveRecord::Migration
  def change
    add_column :flyer_infos, :topimg, :string

    add_column :flyer_infos, :sideimg, :string

  end
end
