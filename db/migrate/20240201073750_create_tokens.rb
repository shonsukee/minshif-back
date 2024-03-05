class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens, comment: "トークン情報" do |t|
      t.references	:user,		type: :string,	foreign_key: true,	comment: "ユーザ情報の外部キー"
      t.text	:access_token,										comment: "アクセストークン"
      t.text	:refresh_token,										comment: "リフレッシュトークン"

      t.timestamps
    end
  end
end
