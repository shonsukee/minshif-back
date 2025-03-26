require 'rails_helper'

RSpec.describe ScheduledShiftMessageJob, type: :job do
	let(:store_name) { 'minshif店' }
	let(:start_time) { Time.zone.parse('2000-01-01 09:00:00.000000000 +0000') }
	let(:end_time) { Time.zone.parse('2000-01-01 18:00:00.000000000 +0000') }
	let(:line_user_id) { "U1234567890" }

	before(:each) do
		@current_user = create(:user, line_user_id: line_user_id)
		store = create(:store, store_name: store_name)
		membership = create(:membership, user: @current_user, store: store)
		create(:shift, membership: membership, shift_date: Date.tomorrow, start_time: start_time, end_time: end_time)
	end

	it 'calls LineBotsController#send_shift_message with the correct user ID' do
		line_bot_controller = instance_double(LineBotsController)
		allow(LineBotsController).to receive(:new).and_return(line_bot_controller)

		jst_start_time = start_time + 9.hours
		jst_end_time = end_time + 9.hours

		expect(line_bot_controller).to receive(:send_shift_message).with(
			line_user_id,
			store_name,
			jst_start_time,
			jst_end_time
		)

		ScheduledShiftMessageJob.new.perform
	end
end
