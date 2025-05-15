require 'rails_helper'

RSpec.describe ScheduledShiftMessageJob, type: :job do
	let(:store_name) { 'minshif店' }
	let(:start_time) { Time.zone.parse('09:00:00') }
	let(:end_time) { Time.zone.parse('18:00:00') }
	let(:line_user_id) { "U1234567890" }

	before(:each) do
		@current_user = create(:user, line_user_id: line_user_id)
		store = create(:store, store_name: store_name)
		membership = create(:membership, user: @current_user, store: store)
		create(:shift, membership: membership, shift_date: Date.tomorrow, start_time: start_time, end_time: end_time)
	end

	it 'calls UserShiftNotificationJob with the correct args' do
		line_bot_controller = instance_double(LineBotsController)
		allow(LineBotsController).to receive(:new).and_return(line_bot_controller)

		tomorrow = Date.tomorrow

		text_lines = []
		text_lines << I18n.t('line_bot.send_shift_message.notify.header', date: tomorrow)
		text_lines << I18n.t('line_bot.send_shift_message.notify.store_name', store_name: store_name)
		text_lines << I18n.t('line_bot.send_shift_message.notify.shift_time',
			start_time: start_time.strftime('%H:%M'),
			end_time: end_time.strftime('%H:%M')
		)
		text_lines << I18n.t('line_bot.send_shift_message.notify.footer')

		expect(UserShiftNotificationJob).to receive(:perform_later).with(
			line_user_id,
			text_lines
		)

		ScheduledShiftMessageJob.new.perform
	end
end
