class RemoveUserManageInfoFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password_digest, :string
    remove_column :users, :remember_me_token, :string
    remove_column :users, :remember_me_token_expired_at, :datetime
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_token_expired_at, :datetime
  end
end
