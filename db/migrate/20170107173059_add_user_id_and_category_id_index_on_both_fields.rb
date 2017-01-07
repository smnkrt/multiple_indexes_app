class AddUserIdAndCategoryIdIndexOnBothFields < ActiveRecord::Migration
  def change
    add_index :items, [:user_id, :category_id]
  end
end
