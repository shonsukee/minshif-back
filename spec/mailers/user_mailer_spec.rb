require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
	describe '#invitation' do
		let(:user) { OpenStruct.new(email: I18n.t('mailer.email.test'), user_name: "test_user") }
		let(:invite_link) { 'https://minshif.com/login?invitation_id=123' }
		let(:manager) { OpenStruct.new(user_name: "manager") }
		subject(:mail) do
			described_class.invitation(user, invite_link, manager).deliver_now
			ActionMailer::Base.deliveries.last
		end

		context 'when send invite email' do
			it { expect(mail.from.first).to eq(I18n.t('mailer.email.main')) }
			it { expect(mail.subject).to eq(I18n.t('mailer.invitation.subject')) }
		end
	end
end
