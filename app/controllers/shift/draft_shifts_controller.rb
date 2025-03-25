class Shift::DraftShiftsController < ApplicationController
	def create
		login_user = User.find_by(email: params[:email])
		if login_user.nil?
			render json: { error: "ユーザが見つかりません" }, status: :not_found
			return
		end

		login_store = Membership.find_by(user_id: login_user.id, current_store: true)
		if login_store.nil?
			render json: { error: I18n.t('store.stores.fetch_staff_list.not_found') }, status: :not_found
			return
		end

		if login_store.privilege == "staff"
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
		params.require(:draft_shifts).map do |shift|
			shift.permit(:id, :email, :date, :start_time, :end_time, :notes, :is_registered, :shift_submission_request_id)
		end
	end
end
