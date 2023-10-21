# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# frozen_string_literal: true

ApplicationRecord.transaction do
    User.delete_all
    Group.delete_all
    Membership.delete_all
    Privilege.delete_all
    Schedule.delete_all
    ScheduleList.delete_all
    
	# 管理者ユーザ
	hashed_password = BCrypt::Password.create("shonsuke")
    User.create(id: 1, user_name: 'shonsuke', email: 'shonsuke@gmail.com', password_digest: hashed_password, privilege: 3)

	# 管理用グループ, 9-18時のホワイト企業
	open_time = Time.parse("09:00:00")
	close_time = Time.parse("18:00:00")
	Group.create(id: 1, group_name: "shonsuke株式会社", open_time: open_time, close_time: close_time)
	Membership.create(id: 1, user_id: 1, group_id: 1, current_group: true)

	# 権限設定
    Privilege.create(id: 1, p_name: 'emp') # employee
    Privilege.create(id: 2, p_name: 'lea') # leader
    Privilege.create(id: 3, p_name: 'adm') # administrator
    
	# スケジュール
	# 2024/01/01 9:00~18:00の仕事
	work_start = Time.parse("09:00:00")
	work_end = Time.parse("18:00:00")
	work_date = Date.parse("2024-1-1")
	ScheduleList.create(id: 1, user_id: 1, title: "Hello New World!", description: "あけおめ", work_start: work_start, work_end: work_end)
	Schedule.create(id: 1, user_id: 1, sl_id: 1, group_id: 1, work_date: work_date)

end