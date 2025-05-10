require "time"

class ScheduledShiftMessageJob < ApplicationJob
	queue_as :default

	def perform
		# 明日シフトに入っている人を抽出
		tomorrow_shift_users = User.joins(:memberships)
			.joins('INNER JOIN shifts ON memberships.id = shifts.membership_id')
			.joins('INNER JOIN stores ON memberships.store_id = stores.id')
			.where.not(line_user_id: nil)
			.where(shifts: { shift_date: Date.tomorrow })
			.order('shifts.start_time ASC')
			.pluck('users.line_user_id', 'shifts.start_time', 'shifts.end_time', 'stores.store_name')

		jst_offset = 9.hours
		tomorrow_shift_users.each do |line_user_id, start_time, end_time, store_name|
			jst_start = start_time + jst_offset
			jst_end = end_time + jst_offset
			UserShiftNotificationJob.perform_later(line_user_id, store_name, jst_start, jst_end)
		end
	end
end
