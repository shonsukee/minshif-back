class ScheduledShiftMessageJob < ApplicationJob
	queue_as :default

	def perform
		# 明日シフトに入っている人を抽出
		tomorrow_shift_users = User.joins(:memberships)
			.joins('INNER JOIN shifts ON memberships.id = shifts.membership_id')
			.where.not(line_user_id: nil)
			.where(shifts: { shift_date: Date.tomorrow })
			.distinct
			.pluck(:line_user_id)

		tomorrow_shift_users.each do |line_user_id|
			LineBotsController.new.send_shift_message(line_user_id)
		end
	end
end
