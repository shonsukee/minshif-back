class Shift::ShiftsController < ApplicationController
	# 店舗全員のシフト取得
	def fetch_shifts
		if input_params[:email].blank?
			render json: { error: I18n.t('errors.messages.email_blank') }, status: :bad_request
			return
		end

		user = User.find_by(email: input_params[:email])
		if user.nil?
			render json: { error: I18n.t('errors.messages.user_not_found') }, status: :not_found
			return
		end

		current_membership = Membership.find_by(user_id: user.id, current_store: true)
		if current_membership.nil?
			render json: { error: I18n.t('errors.messages.store_not_found') }, status: :not_found
			return
		end

		staff_shift_list = fetch_staff_shift_list(current_membership, input_params[:start_date], input_params[:end_date])

		render json: { staff_shift_list: staff_shift_list }, status: :ok
	end

	private

	# 店舗に所属するスタッフのシフト情報抽出
	def fetch_staff_shift_list(membership, start_date, end_date)
		Membership.with_stores(membership.store_id).select(:id, :user_id, :privilege).includes(:user).map do |staff|
			Shift.where(shift_date: start_date..end_date)
				.select { |shift| can_view_shift?(membership, staff, shift) }
				.map { |shift| shift_data(staff, shift) }
		end
	end

	# 管理者か登録済シフトなら取得
	def can_view_shift?(membership, staff, shift)
		(membership.privilege == 'manager' || shift.is_registered) && shift.membership_id == staff.id
	end

	def shift_data(staff, shift)
		{
			id: shift.id,
			email: staff.user.email,
			date: shift.shift_date,
			start_time: shift.start_time,
			end_time: shift.end_time,
			notes: shift.notes,
			is_registered: shift.is_registered,
			shift_submission_request_id: shift.shift_submission_request_id
		}
	end

	def input_params
		params.require(:fetch_shift).permit(:start_date, :end_date, :email)
	end
end