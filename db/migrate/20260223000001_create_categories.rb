class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :category_name, null: false
      t.string :color_code, null: false

      t.timestamps
    end
  end
end
