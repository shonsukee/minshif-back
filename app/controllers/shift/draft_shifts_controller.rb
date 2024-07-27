class Shift::DraftShiftsController < ApplicationController
	before_action :authenticate, only: [:create]

	def create
		if @current_user.memberships.current.first.privilege == "staff"
			render json: { error: I18n.t('shift.draft_shifts.create.no_privilege') }, status: :bad_request
			return
		end

		begin
			Shift.register_draft_shifts!(input_params, @current_user)
			render json: { message: I18n.t('shift.draft_shifts.create.success'), status: :ok }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }, status: :bad_request
		end
	end

	private

	def input_params
		params.require(:draft_shifts).map do |shift|
			shift.permit(:id, :user_name, :date, :start_time, :end_time, :notes, :is_registered, :shift_submission_request_id)
		end
	end
end
