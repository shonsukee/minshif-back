class AddLineUserId < ActiveRecord::Migration[7.0]
    def change
      add_column :users, :line_user_id, :string, comment: "LINE Bot用ユーザID"
    end
end
