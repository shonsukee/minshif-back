class AddUserTokenToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :access_token, :text, comment: 'Google Calendar用アクセストークン'
    add_column :users, :refresh_token, :text, comment: 'Google Calendar用リフレッシュトークン'
  end
end
