class CreateUserLeaderboards < ActiveRecord::Migration
  def change
    create_table :user_leaderboards do |t|
      t.references :user
      t.integer :lbtype
      t.integer :lbvalue
      t.date :weekof

      t.timestamps
    end
    add_index :user_leaderboards, :user_id
  end
end
