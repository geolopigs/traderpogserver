class CreateUserFlyers < ActiveRecord::Migration
  def change
    create_table :user_flyers do |t|
      t.references :user
      t.references :flyer_info

      t.timestamps
    end
    add_index :user_flyers, :user_id
    add_index :user_flyers, :flyer_info_id
  end
end
