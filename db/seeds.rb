ApplicationRecord.transaction do
    User.delete_all
    Group.delete_all
    Schedule.delete_all
    ScheduleList.delete_all
    Membership.delete_all
    
	# 管理者ユーザ
	hashed_password = BCrypt::Password.create("shonsuke")
    User.create(user_name: 'shonsuke', email: 'shonsuke@gmail.com', password_digest: hashed_password, privilege: 3)

	# 管理用グループ, 9-18時のホワイト企業
	open_time = Time.parse("09:00:00")
	close_time = Time.parse("18:00:00")
	Group.create(group_name: "shonsuke株式会社", open_time: open_time, close_time: close_time)
	Membership.create(user_id: User.first.id, group_id: Group.first.id, current_group: true)

	# スケジュール
	# 2024/01/01 9:00~18:00の仕事
	work_start = Time.parse("09:00:00")
	work_end = Time.parse("18:00:00")
	work_date = Date.parse("2024-1-1")
	schedule_list = ScheduleList.create(user_id: User.first.id, title: "Hello New World!", description: "あけおめ", work_start: work_start, work_end: work_end)
	Schedule.create(membership_id: Membership.first.id, title: "Hello New World!", description: "あけおめ", work_date: work_date, work_start: work_start, work_end: work_end)
end