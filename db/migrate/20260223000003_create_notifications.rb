class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :event, null: false, foreign_key: true
      t.datetime :notify_at, null: false

      t.timestamps
    end
  end
end
