class AddCalendarIdAndPrivilegeToMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :calendar_id,	:string
    add_column :memberships, :privilege,	:integer,	null:false
  end
end
