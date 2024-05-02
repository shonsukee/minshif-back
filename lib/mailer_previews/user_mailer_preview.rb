class UserMailerPreview < ActionMailer::Preview
	def invitation_email
	  user = User.where(email: "minshif3420@gmail.com")
	  UserMailer.invitation_email(user)
	end
end
