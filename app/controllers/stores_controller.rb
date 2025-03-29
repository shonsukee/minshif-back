class StoresController < ApplicationController
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

		user = User.find_by(id: input_store_params[:created_by_user_id])
		if user.nil?
			render json: { error: I18n.t('default.errors.messages.user_not_found') }
			return
		end

		ActiveRecord::Base.transaction do
			store.save!
			Membership.reset_current_store(user.id)
			# 店舗作成者は権限2に設定
			Membership.create!(
				user_id: user.id,
				store_id: store.id,
				current_store: true,
				privilege: :manager
			)
			render json: { response: I18n.t('store.stores.create.success') }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }
		end
	end

	private

	def input_store_params
		params.permit(:store_name, :location, :created_by_user_id)
	end
end