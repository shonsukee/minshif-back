class RemoveManagerIdAndCalendarIdFromStores < ActiveRecord::Migration[7.0]
  def change
    remove_column :stores, :manager_id, :string
    remove_column :stores, :calendar_id, :string
  end
end
