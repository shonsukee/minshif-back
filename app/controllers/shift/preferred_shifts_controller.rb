class Shift::PreferredShiftsController < ApplicationController
	def create
		begin
			login_user = User.find_by(email: params[:email])
			Shift.register_preferred_shifts!(input_params, login_user)
			render json: { message: I18n.t('shift.preferred_shifts.create.success') }, status: :ok
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }, status: :bad_request
		end
	end

	private

	def input_params
		params.require(:preferredShifts).map do |shift|
			shift.permit(:shift_submission_request_id, :date, :start_time, :end_time, :notes, :is_registered, :email)
		end
	end
end