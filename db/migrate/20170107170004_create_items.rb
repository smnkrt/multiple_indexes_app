class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :name
      t.references :user
      t.references :category

      t.timestamps null: false
    end
  end
end
