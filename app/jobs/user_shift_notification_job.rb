class UserShiftNotificationJob < ApplicationJob
	queue_as :default

	def perform(line_user_id, text_lines)
		LineBotsController.new.send_shift_message(line_user_id, text_lines)
	end
end
