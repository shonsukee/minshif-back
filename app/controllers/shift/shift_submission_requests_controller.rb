class Shift::ShiftSubmissionRequestsController < ApplicationController
	before_action :authenticate, only: [:create, :wanted]

	def create
		@shift_submission_request = ShiftSubmissionRequest.new(
			store_id: input_params['store_id'],
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
		@current_membership = @current_user.memberships.current.first
		if !@current_membership
			render json: { error: I18n.t('default.message.require_membership') }
			return
		end

		# 募集中のシフト提出依頼を取得
		data = ShiftSubmissionRequest.wanted(@current_membership.store_id)
		if data
			render json: { data: data }, status: :ok
		else
			render json: { error: I18n.t('shift.shift_submission_requests.wanted.not_found') }, status: :bad_request
		end
	end

	private

	def input_params
		params.require(:shift_submission_request).permit(:start_date, :end_date, :deadline_date, :deadline_time, :notes, :store_id)
	end
end
