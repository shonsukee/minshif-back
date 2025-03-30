class StoresController < ApplicationController
	def index
		stores = search_store_info(index_params['id'])
		if stores.is_a?(Hash) && stores[:error]
			render json: stores, status: stores[:status]
			return
		end

		render json: stores
	end

	def create
		store = Store.new(
			store_name: create_params[:store_name],
			location: create_params[:location]
		)
		if !store[:store_name] || store[:store_name] == ""
			render json: { error: I18n.t('store.stores.create.empty') }, status: :unprocessable_entity
			return
		elsif Store.exists?(store_name: store.store_name)
			render json: { error: I18n.t('store.stores.create.already_created') }, status: :unprocessable_entity
			return
		end

		user = User.find_by(id: create_params[:created_by_user_id])
		if user.nil?
			render json: { error: I18n.t('default.errors.messages.user_not_found') }, status: :not_found
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

	def switch
		user_id = switch_params[:user_id]
		store_id = switch_params[:store_id]
		if !Membership.switch_store(user_id, store_id)
			render json: { error: I18n.t('store.stores.switch.failed') }, status: :unprocessable_entity
			return
		end
		stores = search_store_info(user_id)
		if stores.is_a?(Hash) && stores[:error]
			render json: stores, status: stores[:status]
			return
		end

		render json: stores
	end

	private

	def search_store_info(user_id)
		user = User.find_by_user_id(user_id)
		if user.nil?
			return { error: I18n.t('default.errors.messages.user_not_found'), status: :not_found }
		end

		memberships = Membership.find_by_user(user)
		if memberships.empty?
			return { error: I18n.t('user.memberships.index.failed'), status: :not_found }
		end

		Store.find_by_memberships(memberships)
	end

	def index_params
		params.permit(:id)
	end

	def create_params
		params.permit(:store_name, :location, :created_by_user_id)
	end

	def switch_params
		params.permit(:user_id, :store_id)
	end
end