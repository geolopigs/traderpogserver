class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :member
      t.integer :bucks

      t.timestamps
    end
  end
end
