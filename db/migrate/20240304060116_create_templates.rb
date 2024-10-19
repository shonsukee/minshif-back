class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates, comment: "シフトのテンプレート情報" do |t|
      t.references	:user,		foreign_key: true,	type: :string,	comment: "ユーザ情報の外部キー"
      t.time :start_time,		null: false, 						comment: "開始時間"
      t.time :end_time,			null: false, 						comment: "終了時間"
      t.text :notes,						 						comment: "備考"

      t.timestamps
    end
  end
end
