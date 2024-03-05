ApplicationRecord.transaction do
	Shift.delete_all
	Membership.delete_all
	Token.delete_all
	BusinessHour.delete_all
	SpecialBusinessHour.delete_all
	Template.delete_all
	User.delete_all
	Store.delete_all

	# 管理者ユーザ
	picture = 'https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw'
	user = User.create(
		id: '1',
		user_name: 'shonsuke',
		email: 'shonsuke@gmail.com',
		picture: picture,
		privilege: 3
	)

	refresh_token = 'abc'
	access_token = 'abc'
	Token.create(
		user_id: user.id,
		refresh_token: refresh_token,
		access_token: access_token
	)

	# 管理用グループ
	calendar_id = ''
	location = '東京都千代田区永田町１丁目７−１'
	store = Store.create(
		id: '1',
		manager_id: user.id,
		calendar_id: calendar_id,
		store_name: 'スーパーshonsuke',
		location: location
	)

	# 所属
	membership = Membership.create(
		user_id: user.id,
		store_id: store.id,
		current_store: true
	)

	# 営業時間
	# 日:0, 月:1, 火:2, 水:3, 木:4, 金:5, 土:6
	open_time = Time.parse('09:00:00')
	close_time = Time.parse('18:00:00')
	for day_of_week in 1..5 do
		BusinessHour.create(store_id: store.id, day_of_week: day_of_week, open_time: open_time, close_time: close_time)
	end

	# 休業
	open_time = Time.parse('00:00:00')
	close_time = Time.parse('00:00:00')
	BusinessHour.create(store_id: store.id, day_of_week: 6, open_time: open_time, close_time: close_time)
	BusinessHour.create(store_id: store.id, day_of_week: 0, open_time: open_time, close_time: close_time)

	# 特別営業日
	# 24時間営業にする
	special_date = Date.parse('2025-01-01')
	open_time = Time.parse('00:00:00')
	close_time = Time.parse('23:59:59')
	SpecialBusinessHour.create(store_id: store.id, special_date: special_date, open_time: open_time, close_time: close_time, notes: '元旦')

	# テンプレート
	start_time = Time.parse('09:00:00')
	end_time = Time.parse('18:00:00')
	Template.create(user_id: user.id, start_time: start_time, end_time: end_time, notes: '毎週水曜日分')

	# 登録済みシフト
	shift_date = Date.parse('2024-08-01')
	Shift.create(membership_id: membership.id, shift_date: shift_date, start_time: start_time, end_time: end_time, notes: '初出勤', is_registered: false)

	# シフト変更依頼は記述していない
end
