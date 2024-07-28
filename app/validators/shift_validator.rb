require "date"

class ShiftValidator
	def initialize(shift, shift_submission_request_id)
		@shift = shift
	@shift_submission_request_id = shift_submission_request_id
	end

	def validate
		validate_date_range if @shift_submission_request_id.present?
		validate_time
		raise ActiveRecord::RecordInvalid.new(@shift) unless @shift.errors.empty?
	end

	private

	def validate_date_range
	shift_request = ShiftSubmissionRequest.find_by(id: @shift_submission_request_id)
	if shift_request && @shift.shift_date
		# 登録予定のシフト時間
		reg_date = @shift.shift_date.strftime('%Y-%m-%d')

		if shift_request.start_date > Date.parse(reg_date) || shift_request.end_date < Date.parse(reg_date)
		@shift.errors.add(:shift_date, I18n.t("shift.preferred_shifts.create.out_of_range"))
		end
	else
		@shift.errors.add(:shift_date, I18n.t("shift.preferred_shifts.create.no_shift_request"))
	end
	end

	def validate_time
		if @shift.start_time && @shift.end_time
			if @shift.start_time > @shift.end_time
				@shift.errors.add(:start_time, I18n.t("preferred_shifts.create.invalid_time"))
			end
		else
			@shift.errors.add(:start_time, I18n.t("preferred_shifts.create.missing_time"))
		end
	end
end
