class Store::StoreController < ApplicationController
	before_action :authenticate, only: [:create]

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
			store.save
			# 店舗作成者は権限2に設定
			membership = Membership.create(user: @current_user, store: store, privilege: 2)
			render json: { response: I18n.t('store.stores.create.success') }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }
		end
	end

	private

	def input_store_params
		params.require(:store).permit(:store_name, :location)
	end
end