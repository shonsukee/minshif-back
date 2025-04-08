class UserMailerPreview < ActionMailer::Preview
	def invitation_email
	  user = User.where(email: I18n.t('mailer.email.main'))
	  UserMailer.invitation_email(user)
	end
end
