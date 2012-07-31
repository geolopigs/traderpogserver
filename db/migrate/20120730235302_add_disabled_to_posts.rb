class AddDisabledToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :disabled, :boolean

  end
end
