class Store::StoreController < ApplicationController
	def create
		@store = Store.new(
			store_name: input_params[:store_name],
			location: input_params[:location]
		)
		if !@store[:store_name] || @store[:store_name] == ""
			render json: { error: I18n.t('store.stores.create.empty') }
			return
		elsif Store.exists?(store_name: @store.store_name)
			render json: { error: I18n.t('store.stores.create.already_created') }
			return
		end

		begin
			@store.save!
			render json: { response: I18n.t('store.stores.create.success') }
		rescue ActiveRecord::RecordInvalid => e
			render json: { error: e.message }
		end
	end

	private

	def input_params
		params.require(:store).permit(:store_name, :location)
	end
end