class ScheduledShiftMessageJob < ApplicationJob
	queue_as :default

	def perform
		LineBotsController.new.send_shift_message('line_user_id')
	end
end
