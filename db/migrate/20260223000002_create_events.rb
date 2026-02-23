class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.text :memo
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.boolean :temporary, null: false

      t.timestamps
    end
  end
end
