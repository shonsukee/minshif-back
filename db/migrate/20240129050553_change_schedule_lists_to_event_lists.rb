class ChangeScheduleListsToEventLists < ActiveRecord::Migration[7.0]
  def change
	rename_table :schedule_lists, :event_lists
  end
end
