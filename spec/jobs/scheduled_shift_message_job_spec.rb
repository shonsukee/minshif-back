require 'rails_helper'

RSpec.describe ScheduledShiftMessageJob, type: :job do
	it 'calls LineBotsController#send_shift_message with the correct user ID' do
		user_id = 'line_user_id'
		line_bot_controller = instance_double(LineBotsController)
		allow(LineBotsController).to receive(:new).and_return(line_bot_controller)

		expect(line_bot_controller).to receive(:send_shift_message).with(user_id)
		ScheduledShiftMessageJob.new.perform
	end
end
