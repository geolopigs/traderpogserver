class AddFieldsToUserFlyers < ActiveRecord::Migration
  def change
    add_column :user_flyers, :level, :integer

    add_column :user_flyers, :colorindex, :integer

  end
end
