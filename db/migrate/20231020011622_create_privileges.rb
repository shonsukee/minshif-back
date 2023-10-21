class CreatePrivileges < ActiveRecord::Migration[7.0]
  def change
    create_table :privileges, comment: "権限" do |t|
      t.string   :p_name,     comment: "権限名"

      t.timestamps
    end
  end
end
