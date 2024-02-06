ApplicationRecord.transaction do
	Membership.delete_all
	EventList.delete_all
	Token.delete_all
	User.delete_all
	Group.delete_all

	# 管理者ユーザ
	picture = 'https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw'
	user = User.create(user_name: 'shonsuke', email: 'shonsuke@gmail.com', picture: picture, privilege: 3)

	refresh_token = 'abc'
	access_token = 'abc'
	Token.create(user_id: user.id, refresh_token: refresh_token, access_token: access_token)

	# 管理用グループ, 9-18時のホワイト企業
	open_time = Time.parse('09:00:00')
	close_time = Time.parse('18:00:00')
	group = Group.create(group_name: 'shonsuke株式会社', open_time: open_time, close_time: close_time)
	Membership.create(user_id: user.id, group_id: group.id, current_group: true)

	# スケジュール
	# 2024/01/01 9:00~18:00の仕事
	work_start = Time.parse('09:00:00')
	work_end = Time.parse('18:00:00')
	EventList.create(user_id: User.first.id, title: '出勤', description: 'フルタイム', work_start: work_start, work_end: work_end)

	work_start = Time.parse('12:00:00')
	EventList.create(user_id: User.first.id, title: '昼出勤', description: '昼から', work_start: work_start, work_end: work_end)
end