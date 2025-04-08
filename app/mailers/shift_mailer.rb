class ShiftMailer < ApplicationMailer
	def registration(shifts, target, subject)
		@shifts = shifts
		@target = target
	  mail(to: @target.email, subject: subject)
	end
end
