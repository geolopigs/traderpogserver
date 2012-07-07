class CreateUserconfigs < ActiveRecord::Migration
  def change
    create_table :userconfigs do |t|
      t.string :key
      t.string :value
      t.references :user

      t.timestamps
    end
    add_index :userconfigs, :user_id
  end
end
