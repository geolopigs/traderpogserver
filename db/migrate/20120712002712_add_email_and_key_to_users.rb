class AddEmailAndKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string

    add_column :users, :secretkey, :string

  end
end
