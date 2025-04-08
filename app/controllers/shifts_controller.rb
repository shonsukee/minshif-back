class ShiftsController < ApplicationController
	# 店舗全員のシフト取得
	def index
		if input_index_params[:id].blank?
			render json: { error: I18n.t('default.errors.messages.id_blank') }, status: :bad_request
			return
		end

		user = User.find_by(id: input_index_params[:id])
		if user.nil?
			render json: { error: I18n.t('default.errors.messages.user_not_found') }, status: :not_found
			return
		end

		membership = Membership.find_by(user_id: user.id, current_store: true)
		if membership.nil?
			render json: { error: I18n.t('default.errors.messages.store_not_found') }, status: :not_found
			return
		end

		staff_shift_list = fetch_staff_shift_list(membership, input_index_params[:start_date], input_index_params[:end_date])

		render json: staff_shift_list, status: :ok
	end

	def create
		user = User.find_by(email: params[:email])
		if user.nil?
			render json: { error: "ユーザが見つかりません" }, status: :not_found
			return
		end

		store = Membership.find_by(user_id: user.id, current_store: true)
		if store.nil?
			render json: { error: I18n.t('store.stores.fetch.not_found') }, status: :not_found
			return
		end

		if store.privilege == "staff"
			render json: { error: I18n.t('shift.shifts.create.no_privilege') }, status: :bad_request
			return
		end

		begin
			shifts = input_create_params
			Shift.register_shifts!(shifts, user)

			# 予定されているシフトを個別に収集
			scheduled_shifts = Hash.new { |h, k| h[k] = [] }
			for shift in shifts do
				target = User.find_by(email: shift[:email])
				start_time = shift[:start_time].is_a?(String) ? Time.zone.parse(shift[:start_time]) : shift[:start_time]
				end_time = shift[:end_time].is_a?(String) ? Time.zone.parse(shift[:end_time]) : shift[:end_time]
				scheduled_shifts[target] << {
					date: shift[:date],
					start_time: start_time,
					end_time: end_time
				}
			end

			# 非同期で成功メッセージを送信
			scheduled_shifts.each do |target, shifts|
				ShiftMailer.registration(shifts, target, I18n.t('mailer.shift.create')).deliver_later
			end

			render json: { message: I18n.t('shift.shifts.create.success') }, status: :ok
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }, status: :bad_request
		end
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

	def input_index_params
		params.require(:fetch_shift).permit(:start_date, :end_date)
		params.permit(:id)
	end


	def input_create_params
		params.require(:shifts).map do |shift|
			shift.permit(:id, :email, :date, :start_time, :end_time, :notes, :is_registered, :shift_submission_request_id)
		end
	end
end