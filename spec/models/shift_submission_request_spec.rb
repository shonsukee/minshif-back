require 'rails_helper'

describe ShiftSubmissionRequest, type: :model do
	describe 'create a new shift submission request' do
		before do
			@store = create(:store)
		end

		let(:shift_submission_request) do
			ShiftSubmissionRequest.new(
				store_id: @store.id,
				start_date: start_date,
				end_date: end_date,
				deadline_date: deadline_date,
				deadline_time: "00:00",
				notes: "This is a test."
			)
		end
		let(:start_date) { Date.new(2026, 01, 01) }
		let(:end_date) { Date.new(2026, 01, 31) }
		let(:deadline_date) { Date.new(2025, 12, 25) }

		context "with valid attributes" do
			it "when start_date is specific date" do
				expect(shift_submission_request).to be_valid
			end

			it "when start_date is today" do
				shift_submission_request.start_date = Date.today
				shift_submission_request.deadline_date = Date.today
				expect(shift_submission_request).to be_valid
			end
		end

		context "with invalid attributes" do
			it "when date is blank" do
				shift_submission_request.start_date = ""
				shift_submission_request.end_date = ""
				expect(shift_submission_request).to be_invalid
			end

			it "when start_date is in the past" do
				shift_submission_request.start_date = Date.new(2020, 01, 01)
				shift_submission_request.deadline_date = Date.new(2019, 12, 31)
				expect(shift_submission_request).to be_invalid
			end

			it "when end_date is in the past" do
				shift_submission_request.end_date = Date.new(2020, 01, 01)
				expect(shift_submission_request).to be_invalid
			end


			it "when start_date is less than end_date" do
				shift_submission_request.end_date = Date.new(2025, 12, 30)
				expect(shift_submission_request).to be_invalid
			end

			it "when deadline_date is less than start_date" do
				shift_submission_request.deadline_date = Date.new(2026, 01, 15)
				expect(shift_submission_request).to be_invalid
			end
		end
	end
end
