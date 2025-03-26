class ShiftSubmissionRequestsController < ApplicationController
	def create
		# ログインユーザの所属情報を取得
		login_user = User.find_by(email: params[:email])
		if login_user.nil?
			render json: { error: I18n.t('store.stores.fetch.not_found_user') }, status: :bad_request
			return
		end

		login_store = Membership.find_by(user_id: login_user.id, current_store: true)
		if login_store.nil?
			render json: { error: I18n.t('store.stores.fetch.not_found_membership') }, status: :bad_request
			return
		end

		@shift_submission_request = ShiftSubmissionRequest.new(
			store_id: login_store.store_id,
			start_date: input_params['start_date'],
			end_date: input_params['end_date'],
			deadline_date: input_params['deadline_date'],
			deadline_time: input_params['deadline_time'],
			notes: input_params['notes'],
		)

		if @shift_submission_request.save
			render json: { msg: I18n.t('shift.shift_submission_requests.create.success') }, status: :ok
		else
			render json: { error: @shift_submission_request.errors.full_messages }, status: :bad_request
		end
	end

	def wanted
		# ログインユーザの所属情報を取得
		login_user = User.find_by(email: params[:email])
		if login_user.nil?
			render json: { error: "ユーザが見つかりません" }, status: :not_found
			return
		end

		login_store = Membership.find_by(user_id: login_user.id, current_store: true)
		if login_store.nil?
			render json: { error: I18n.t('store.stores.fetch.not_found') }, status: :not_found
			return
		end

		# 募集中のシフト提出依頼を取得
		data = ShiftSubmissionRequest.wanted(login_store)
		if data
			render json: { data: data }, status: :ok
		else
			render json: { error: I18n.t('shift.shift_submission_requests.wanted.not_found') }, status: :bad_request
		end
	end

	private

	def input_params
		params.require(:shift_submission_request).permit(:start_date, :end_date, :deadline_date, :deadline_time, :notes)
	end
end
