class CreateFlyerInfos < ActiveRecord::Migration
  def change
    create_table :flyer_infos do |t|
      t.integer :capacity
      t.integer :speed
      t.integer :stormresist
      t.integer :multiplier

      t.timestamps
    end
  end
end
