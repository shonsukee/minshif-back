require "date"

class ShiftValidator
	def initialize(shift, user)
		@shift = shift
		@user = user
	end

	def validate
		validate_date_range
		validate_time
		raise ActiveRecord::RecordInvalid.new(@shift) unless @shift.errors.empty?
	end

	private

	def validate_date_range
		shift_membership = @user.memberships.current.first
		shift_request = ShiftSubmissionRequest.find_by(store_id: shift_membership.store_id)
		reg_date = @shift.shift_date.strftime('%Y-%m-%d')

		if !shift_request || Date.parse(reg_date) < shift_request.start_date || Date.parse(reg_date) > shift_request.end_date
			@shift.errors.add(:shift_date, I18n.t("shift.preferred_shifts.create.out_of_range"))
		end
	end

	def validate_time
		if @shift.start_time > @shift.end_time
			@shift.errors.add(:start_time, I18n.t("preferred_shifts.create.invalid_time"))
		end
	end
end
