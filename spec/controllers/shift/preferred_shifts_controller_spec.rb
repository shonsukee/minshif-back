require 'rails_helper'

RSpec.describe Shift::PreferredShiftsController, type: :controller do
	describe 'POST #create' do
		let(:user) { create(:user) }
		let!(:membership) { create(:membership, user: user, current_store: true) }
		let(:store) { create(:store) }
		let(:shift_submission_request) { create(:shift_submission_request, store: store) }
		let(:params) {{
			email: user.email,
			preferredShifts: [
				{
					shift_submission_request_id: shift_submission_request.id,
					date: date,
					start_time: start_time,
					end_time: end_time,
					notes: notes,
					is_registered: false
				}
			]
		}}

		let(:date) { Date.today }
		let(:start_time) { Time.parse('09:00:00') }
		let(:end_time) { Time.parse('18:00:00') }
		let(:notes) { 'test note' }

		let(:shift_request) { build(:shift_submission_request, store_id: membership.store_id, start_date: Date.yesterday, end_date: Date.tomorrow) }

		before do
			allow(ShiftSubmissionRequest).to receive(:find_by).and_return(shift_request)
		end

		context 'with valid attributes' do
			context 'when the date is a single' do
				it 'is valid and adds a new preferred shift' do
					post :create, params: params
					expect(response).to have_http_status(200)
				end

				it 'is valid and note is nil' do
					modified_params = params.deep_dup
					modified_params[:preferredShifts][0][:notes] = nil
					post :create, params: modified_params
					expect(response).to have_http_status(200)
				end
			end

			context 'when dates are multiple' do
				let(:params) {{
					email: user.email,
					preferredShifts: [
						{shift_submission_request_id: shift_submission_request.id, date: date, start_time: start_time, end_time: end_time, notes: notes, is_registered: false},
						{shift_submission_request_id: shift_submission_request.id, date: date, start_time: start_time, end_time: end_time, notes: notes, is_registered: false},
						{shift_submission_request_id: shift_submission_request.id, date: date, start_time: start_time, end_time: end_time, notes: notes, is_registered: false}
					]
				}}

				it 'is valid and adds a new preferred shift' do
					post :create, params: params
					expect(response).to have_http_status(200)
				end
			end
		end

		context 'with invalid attributes' do
			context 'when setting incorrect date' do
				let(:date) { Date.parse('2026-01-07') }
				it 'is not valid and adds an error on shift_date' do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end

			context 'when setting incorrect time' do
				let(:start_time) { Time.parse('18:00:00') }
				let(:end_time) { Time.parse('09:00:00') }

				it 'is not valid and adds an error on start_time' do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end
		end
	end
end