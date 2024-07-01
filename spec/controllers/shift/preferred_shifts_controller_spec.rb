require 'rails_helper'

RSpec.describe Shift::PreferredShiftsController, type: :controller do
	describe 'POST #create' do
		let(:user) { create(:user) }
		let!(:membership) { create(:membership, user: user, current_store: true) }
		let(:token) { Jwt::TokenProvider.call(user.id) }
		let(:store) { create(:store) }
		let(:shift_submission_request) { create(:shift_submission_request, store: store) }
		let(:params) {{
			preferredShifts: [
				{shift_submission_request_id: shift_submission_request.id, date: date, startTime: startTime, endTime: endTime, notes: notes}
			]
		}}

		let(:date) { Date.today }
		let(:startTime) { Time.parse('09:00:00') }
		let(:endTime) { Time.parse('18:00:00') }
		let(:notes) { 'test note' }

		let(:shift_request) { build(:shift_submission_request, store_id: membership.store_id, start_date: Date.yesterday, end_date: Date.tomorrow) }

		before do
			allow(ShiftSubmissionRequest).to receive(:find_by).and_return(shift_request)
		end

		context 'with valid attributes' do
			before do
				request.headers['Authorization'] = "Bearer #{token}"
			end

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
					preferredShifts: [
						{shift_submission_request_id: shift_submission_request.id, date: date, startTime: startTime, endTime: endTime, notes: notes},
						{shift_submission_request_id: shift_submission_request.id, date: date, startTime: startTime, endTime: endTime, notes: notes},
						{shift_submission_request_id: shift_submission_request.id, date: date, startTime: startTime, endTime: endTime, notes: notes}
					]
				}}

				it 'is valid and adds a new preferred shift' do
					post :create, params: params
					expect(response).to have_http_status(200)
				end
			end
		end

		context 'with invalid attributes' do
			before do
				request.headers['Authorization'] = "Bearer #{token}"
			end

			context 'when setting incorrect date' do
				let(:date) { Date.parse('2026-01-07') }
				it 'is not valid and adds an error on shift_date' do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end

			context 'when setting incorrect time' do
				let(:startTime) { Time.parse('18:00:00') }
				let(:endTime) { Time.parse('09:00:00') }

				it 'is not valid and adds an error on startTime' do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end
		end
	end
end