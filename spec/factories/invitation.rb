FactoryBot.define do
	factory :invitation do
		association :membership
		invitation_id { 1 }
		invitee_email { I18n.t('user_mailer.email.invitation') }
	end
end
