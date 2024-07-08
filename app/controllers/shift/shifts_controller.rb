class Shift::ShiftsController < ApplicationController
	before_action :authenticate, only: [:fetch_shifts]

	# 店舗全員のシフト取得
	def fetch_shifts
		login_store = Membership.with_users(@current_user.id).current
		if login_store.none?
			render json: { error: I18n.t('shift.shifts.fetch_shifts.login_required') }, status: :not_found
			return
		end

		# 店舗のスタッフ一覧取得
		staff_memberships = Membership.with_stores(login_store[0].store_id)
								.select(:id, :user_id, :privilege)
								.includes(:user)

		# 全シフト情報取得
		staff_shift_list = staff_memberships.map do |staff|
			staff_shifts = Shift.where(shift_date: input_params['start_date']..input_params['end_date'])

			staff_shifts.map do |shift|
				# スタッフは希望シフトを閲覧できない
				if login_store[0].privilege == "staff" && shift.is_registered == false
					next
				end

				{
					id: staff.user.id,
					user_name: staff.user.user_name,
					date: shift.shift_date,
					start_time: shift.start_time,
					end_time: shift.end_time,
					notes: shift.notes,
					is_registered: shift.is_registered
				}
			end
		end

		render json: { staff_shift_list: staff_shift_list }, status: :ok
	end

	private

	def input_params
		params.require(:fetch_shift).permit(:start_date, :end_date)
	end
end