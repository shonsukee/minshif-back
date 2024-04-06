class RemovePrivilegeFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :privilege, :integer
  end
end
