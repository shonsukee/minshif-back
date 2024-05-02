class CreateInvitation < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations, comment: "招待情報" do |t|
      t.references :membership,	foreign_key: true, type: :bigint,	comment: "招待者の所属情報の外部キー"
      t.string :invite_link,	null: false,						comment: "招待リンク"
      t.string :invitee_email, null: false,							comment: "被招待者メールアドレス"
      t.datetime :expired_at,										comment: "有効期限"

      t.timestamps
    end
  end
end
