require 'rails_helper'

describe Shift::ShiftSubmissionRequestsController, type: :controller do
	describe 'POST #create' do
		let(:params) {{
			shift_submission_request: {
				start_date: start_date,
				end_date: end_date,
				deadline_date: deadline_date,
				deadline_time: "00:00",
				notes: "This is a test."
			}
		}}

		context "with valid attributes" do
			before do
				shift_submission_request_mock = instance_double(
					"ShiftSubmissionRequest",
					save: true
				)
				allow(ShiftSubmissionRequest).to receive(:new).and_return(shift_submission_request_mock)
			end

			let(:end_date) { Date.new(2026, 01, 31) }
			let(:deadline_date) { Date.new(2025, 12, 25) }

			context "when start_date is specific date" do
				let(:start_date) { Date.new(2026, 01, 01) }
				it "creates a new shift submission request" do
					post :create, params: params

					expect(response).to have_http_status(200)
					expect(response.body).to include(I18n.t('shift.shift_submission_requests.create.success'))
				end
			end

			context "when start_date is today" do
				let(:start_date) { Date.today }
				it "creates a new shift submission request" do
					post :create, params: params

					expect(response).to have_http_status(200)
					expect(response.body).to include(I18n.t('shift.shift_submission_requests.create.success'))
				end
			end
		end

		context "with invalid attributes" do
			context "when start_date is in the past" do
				let(:start_date) { Date.new(2020, 01, 01) }
				let(:end_date) { Date.today }
				let(:deadline_date) { Date.new(2019, 12, 30) }
				it "do not create a shift submission request" do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end

			context "when end_date is in the past" do
				let(:start_date) { Date.today }
				let(:end_date) { Date.new(2020, 01, 01) }
				let(:deadline_date) { Date.new(2019, 12, 30) }
				it "do not create a shift submission request" do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end

			context "when start_date is less than end_date" do
				let(:start_date) { Date.new(2026, 01, 01) }
				let(:end_date) { Date.new(2025, 12, 30) }
				let(:deadline_date) { Date.new(2025, 12, 25) }
				it "do not create a shift submission request" do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end

			context "when deadline_date is less than start_date" do
				let(:start_date) { Date.new(2026, 01, 01) }
				let(:end_date) { Date.new(2026, 01, 30) }
				let(:deadline_date) { Date.new(2026, 01, 15) }
				it "do not create a shift submission request" do
					post :create, params: params
					expect(response).to have_http_status(400)
				end
			end
		end

	end
end