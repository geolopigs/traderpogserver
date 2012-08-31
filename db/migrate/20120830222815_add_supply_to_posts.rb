class AddSupplyToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :supply, :integer

  end
end
