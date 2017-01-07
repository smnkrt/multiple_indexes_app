class AddCategoryIdIndexToItems < ActiveRecord::Migration
  def change
    add_index :items, :category_id
  end
end
