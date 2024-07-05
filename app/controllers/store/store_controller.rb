class Store::StoreController < ApplicationController
	before_action :authenticate, only: [:create, :fetch_staff_list]

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

		begin
			store.save!
			# 店舗作成者は権限2に設定
			Membership.create!(
				user_id: @current_user.id,
				store_id: store.id,
				current_store: true,
				privilege: 2
			)
			render json: { response: I18n.t('store.stores.create.success') }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }
		end
	end

	def fetch_staff_list
		login_store = Membership.with_users(@current_user.id).current
		if login_store.none?
			render json: { error: I18n.t('store.stores.fetch_staff_list.not_found') }, status: :not_found
			return
		end

		staff_memberships = Membership.with_stores(login_store[0].store_id)
										.select(:id, :user_id, :privilege)
										.includes(:user)

		staff_list = staff_memberships.map do |staff|
			{ id: staff.id, privilege: staff.privilege, user_name: staff.user.user_name }
		end

		render json: { staff_list: staff_list }, status: :ok
	end

	private

	def input_store_params
		params.require(:store).permit(:store_name, :location)
	end
end