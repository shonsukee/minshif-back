class UserMailer < ApplicationMailer
	def invitation(invitee_user, invite_link, manager)
		@invitee_user = invitee_user
		@invite_link = invite_link
		@manager = manager
		mail(to: @invitee_user.email, subject: I18n.t('mailer.invitation.subject'))
	end
end
