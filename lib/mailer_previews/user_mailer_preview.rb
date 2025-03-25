class UserMailerPreview < ActionMailer::Preview
	def invitation_email
	  user = User.where(email: I18n.t('user_mailer.email.main'))
	  UserMailer.invitation_email(user)
	end
end
