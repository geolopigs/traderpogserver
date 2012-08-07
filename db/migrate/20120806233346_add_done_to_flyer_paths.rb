class AddDoneToFlyerPaths < ActiveRecord::Migration
  def change
    add_column :flyer_paths, :done, :boolean

  end
end
