class Shift::PreferredShiftsController < ApplicationController
	before_action :authenticate, only: [:create]

	def create
		begin
			validated_shifts = input_params.map do |shift_params|
				shift = Shift.new(
					membership_id: @current_user.memberships.current.first.id,
					shift_date: shift_params[:date],
					start_time: shift_params[:startTime],
					end_time: shift_params[:endTime],
					notes: shift_params[:notes]
				)

				validator = ShiftValidator.new(shift, @current_user)
				validator.validate
				shift
			end

			Shift.create_preferred_shifts!(validated_shifts, @current_user)
			render json: { msg: I18n.t('shift.preferred_shifts.create.success'), status: 200 }, status: :ok
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.record.errors.full_messages }, status: :bad_request
		end
	end

	private

	def input_params
		params.require(:preferredShifts).map do |shift|
			shift.permit(:date, :startTime, :endTime, :notes)
		end
	end
end