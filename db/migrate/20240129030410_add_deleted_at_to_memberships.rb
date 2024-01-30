class AddDeletedAtToMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :memberships, :deleted_at, :datetime, comment: '削除日時'
  end
end
