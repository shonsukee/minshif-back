require 'rails_helper'

RSpec.describe LineBotsController, type: :controller do
	let(:client) { instance_double(Line::Bot::Client) }
	let(:user_id) { 'line_user_id' }
	let(:store_name) { 'minshif店' }
	let(:start_time) { Time.zone.parse('2027-01-01 09:00') }
	let(:end_time) { Time.zone.parse('2027-01-01 18:00') }

	before do
		allow(controller).to receive(:client).and_return(client)
	end

	describe '#send_shift_message' do
		before do
			allow(controller).to receive(:client).and_return(client)
		end

		it 'sends a shift reminder message to the specified user' do
			tomorrow = Date.tomorrow.strftime('%m/%d')
			text_lines = []
			text_lines << I18n.t('line_bot.send_shift_message.notify.header', date: tomorrow)
			text_lines << I18n.t('line_bot.send_shift_message.notify.store_name', store_name: store_name)
			text_lines << I18n.t('line_bot.send_shift_message.notify.shift_time',
				start_time: start_time,
				end_time: end_time
			)
			text_lines << I18n.t('line_bot.send_shift_message.notify.footer')

			expected_message = {
				type: 'text',
				text: text_lines
			}

			expect(client).to receive(:push_message).with(user_id, expected_message)
			controller.send_shift_message(user_id, text_lines)
		end
	end
end
