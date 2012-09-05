class AddMetersTraveledToUserFlyers < ActiveRecord::Migration
  def change
    add_column :user_flyers, :meterstraveled, :float

  end
end
