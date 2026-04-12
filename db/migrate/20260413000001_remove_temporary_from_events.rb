class RemoveTemporaryFromEvents < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :temporary, :boolean
  end
end
