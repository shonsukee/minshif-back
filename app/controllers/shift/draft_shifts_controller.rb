class Shift::DraftShiftsController < ApplicationController
	def create
		login_user = User.find_by(email: input_params[:email]).first
		if login_user.nil?
			render json: { error: "ユーザが見つかりません" }, status: :not_found
			return
		end

		if login_user.privilege == "staff"
			render json: { error: I18n.t('shift.draft_shifts.create.no_privilege') }, status: :bad_request
			return
		end

		begin
			Shift.register_draft_shifts!(input_params, login_user)
			render json: { message: I18n.t('shift.draft_shifts.create.success') }, status: :ok
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }, status: :bad_request
		end
	end

	private

	def input_params
		params.permit(:email)
		params.require(:draft_shifts).map do |shift|
			shift.permit(:id, :user_name, :date, :start_time, :end_time, :notes, :is_registered, :shift_submission_request_id)
		end
	end
end
