class Shift::PreferredShiftsController < ApplicationController
	before_action :authenticate, only: [:create]

	def create
		begin
			Shift.register_preferred_shifts!(input_params, @current_user)
			render json: { msg: I18n.t('shift.preferred_shifts.create.success') }, status: :ok
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }, status: :bad_request
		end
	end

	private

	def input_params
		params.require(:preferredShifts).map do |shift|
			shift.permit(:shift_submission_request_id, :date, :start_time, :end_time, :notes, :is_registered)
		end
	end
end