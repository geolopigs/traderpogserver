class ChangeDataTypeForFacebookFriends < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :fb_friends, :text
    end
  end

  def down
    change_table :users do |t|
      t.change :fb_friends, :string
    end
  end
end
