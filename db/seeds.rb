ApplicationRecord.transaction do
    User.delete_all
    Group.delete_all
    EventList.delete_all
    Membership.delete_all

	# 管理者ユーザ
	refresh_token = "abc"
	access_token = "abc"
    User.create(user_name: 'shonsuke', email: 'shonsuke@gmail.com', privilege: 3, access_token: access_token, refresh_token: refresh_token)

	# 管理用グループ, 9-18時のホワイト企業
	open_time = Time.parse("09:00:00")
	close_time = Time.parse("18:00:00")
	Group.create(group_name: "shonsuke株式会社", open_time: open_time, close_time: close_time)
	Membership.create(user_id: User.first.id, group_id: Group.first.id, current_group: true)

	# スケジュール
	# 2024/01/01 9:00~18:00の仕事
	work_start = Time.parse("09:00:00")
	work_end = Time.parse("18:00:00")
	EventList.create(user_id: User.first.id, title: "出勤", description: "フルタイム", work_start: work_start, work_end: work_end)

	work_start = Time.parse("12:00:00")
	EventList.create(user_id: User.first.id, title: "昼出勤", description: "昼から", work_start: work_start, work_end: work_end)
end