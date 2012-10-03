class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :user
      t.references :post
      t.integer :amount
      t.string :fbid

      t.timestamps
    end
    add_index :sales, :user_id
    add_index :sales, :post_id
  end
end
