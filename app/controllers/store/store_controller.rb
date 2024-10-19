class Store::StoreController < ApplicationController
	def create
		store = Store.new(
			store_name: input_store_params[:store_name],
			location: input_store_params[:location]
		)
		if !store[:store_name] || store[:store_name] == ""
			render json: { error: I18n.t('store.stores.create.empty') }, status: :unprocessable_entity
			return
		elsif Store.exists?(store_name: store.store_name)
			render json: { error: I18n.t('store.stores.create.already_created') }, status: :unprocessable_entity
			return
		end

		ActiveRecord::Base.transaction do
			login_user = User.find_by(email: input_store_params[:email])
			store.save!
			# 店舗作成者は権限2に設定
			Membership.create!(
				user_id: login_user.id,
				store_id: store.id,
				current_store: true,
				privilege: :manager
			)
			render json: { response: I18n.t('store.stores.create.success') }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }
		end
	end

	def fetch_staff_list
		email = params[:email]
		if email == "undefined"
			render json: { error: "emailがありません" }, status: :bad_request
			return
		end
		login_user = User.find_by(email: email)
		if login_user.nil?
			render json: { error: "ユーザが見つかりません" }, status: :not_found
			return
		end

		login_store = Membership.find_by(user_id: login_user.id, current_store: true)
		if login_store.nil?
			render json: { error: I18n.t('store.stores.fetch_staff_list.not_found') }, status: :not_found
			return
		end

		staff_memberships = Membership.with_stores(login_store.store_id)
										.select(:id, :user_id, :privilege)
										.includes(:user)

		staff_list = staff_memberships.map do |staff|
			{
				id: staff.id,
				privilege: staff.privilege,
				user_name: staff.user.user_name,
				email: staff.user.email,
				picture: staff.user.picture
			}
		end

		render json: { staff_list: staff_list }, status: :ok
	end

	private

	def input_store_params
		params.permit(:store_name, :location, :email)
	end
end