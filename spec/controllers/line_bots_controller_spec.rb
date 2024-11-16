require 'rails_helper'

RSpec.describe LineBotsController, type: :controller do
	let(:client) { instance_double(Line::Bot::Client) }
	let(:user_id) { 'line_user_id' }

	before do
		allow(controller).to receive(:client).and_return(client)
	end

	describe '#send_shift_message' do
		it 'sends a shift reminder message to the specified user' do
			message = {
				type: 'text',
				text: '明日シフトがあります！'
			}
			expect(client).to receive(:push_message).with(user_id, message)
			controller.send_shift_message(user_id)
		end
	end
end
