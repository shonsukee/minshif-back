class UserShiftNotificationJob < ApplicationJob
	queue_as :default

	def perform(line_user_id, store_name, start_time, end_time)
		LineBotsController.new.send_shift_message(line_user_id, store_name, start_time, end_time)
	end
end
