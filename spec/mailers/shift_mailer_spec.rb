require "rails_helper"

RSpec.describe ShiftMailer, type: :mailer do
	describe '#registration' do
		let(:user) { create(:user) }
		let(:shift) do
			{
				"id": nil,
				"email": I18n.t('mailer.email.test'),
				"date": "2030-01-01",
				"start_time": Time.zone.parse("2000-01-01T09:00:00.000+09:00"),
				"end_time": Time.zone.parse("2000-01-01T13:00:00.000+09:00"),
				"notes": "test shift1",
				"is_registered": true,
				"shift_submission_request_id": nil
			}
		end

		subject(:mail) do
			described_class.registration([shift], user, I18n.t('mailer.shift.create')).deliver_now
			ActionMailer::Base.deliveries.last
		end

		it "includes user name in the text" do
			body = mail.html_part.body.decoded
			expect(body).to include(user[:user_name])
		end

		it "includes all shift information" do
			body = mail.html_part.body.decoded
			expect(body).to include("2030-01-01")
			expect(body).to include("09:00")
			expect(body).to include("13:00")
		end
	end
end
