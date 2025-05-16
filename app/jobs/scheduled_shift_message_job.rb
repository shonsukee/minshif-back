class ScheduledShiftMessageJob < ApplicationJob
	queue_as :default

	def perform
		# 明日シフトに入っている人を抽出
		tomorrow = Date.tomorrow
		tomorrow_shifts = Shift
			.joins(membership: [:user, :store])
			.where(shift_date: tomorrow)
			.where.not(users: { line_user_id: nil })
			.order(start_time: :asc)
			.pluck('users.line_user_id', 'shifts.start_time', 'shifts.end_time', 'stores.store_name')

		grouped = tomorrow_shifts.group_by { |line_user_id, _, _, _| line_user_id }

		grouped.each do |line_user_id, user_shifts|
			text_lines = []
			text_lines << I18n.t('line_bot.send_shift_message.notify.header', date: tomorrow)

			last_store_name = nil

			user_shifts.each do |_, start_time, end_time, store_name|
				if store_name != last_store_name
					text_lines << I18n.t('line_bot.send_shift_message.notify.store_name', store_name: store_name)
					last_store_name = store_name
				end

				start_jst = start_time.in_time_zone("Tokyo").strftime("%H:%M")
				end_jst   = end_time.in_time_zone("Tokyo").strftime("%H:%M")

				text_lines << I18n.t('line_bot.send_shift_message.notify.shift_time',
					start_time: start_jst,
					end_time: end_jst
				)
			end
			text_lines << I18n.t('line_bot.send_shift_message.notify.footer')

			UserShiftNotificationJob.perform_later(line_user_id, text_lines)
		end
	end
end
