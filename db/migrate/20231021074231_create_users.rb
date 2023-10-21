class CreateUsers < ActiveRecord::Migration[7.0]
	def change
	  create_table :users,           comment: "ユーザ情報" do |t|
		t.string   :user_name,       comment: "ユーザ名"
		t.string   :email,           comment: "メールアドレス",     unique: true
		t.string   :password_digest, comment: "ハッシュ化パスワード"
		t.integer  :privilege,       comment: "権限",             default: 1
  
		t.timestamps
	  end
	end
  end
  