require 'rails_helper'

RSpec.describe StoresController, type: :controller do
	describe 'POST #create' do
		let(:input_store_params) {{
			created_by_user_id: @current_user.id,
			store_name: store_name,
			location: '木ノ葉隠れの里',
		}}

		before(:each) do
			@current_user = create(:user)
			allow(Jwt::UserAuthenticator).to receive(:call).and_return(@current_user)
		end

		context "with valid attributes" do
			let(:store_name) { "ラーメン一楽" }
			it "creates a new Store" do
				expect{
					post :create, params: input_store_params
				}.to change(Store, :count).by(1)

				expect(JSON.parse(response.body)).to eq({
					"response"	=> I18n.t('store.stores.create.success')
				})
				expect(response).to have_http_status(200)
			end
		end

		context "with invalid attributes" do
			let(:store_name) { "" }
			it "does not create a new Store" do
				expect {
					post :create, params: input_store_params
				}.to change(Store, :count).by(0)

				expect(JSON.parse(response.body)).to eq({
					"error"	=> I18n.t('store.stores.create.empty')
				})
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end

		context "when store already exists" do
			let(:store_name) { "ラーメン一楽" }
			before do
				Store.create!(
					store_name: input_store_params[:store_name],
					location: input_store_params[:location]
				)
			end

			it "does not allow duplicate store names" do
				expect {
					post :create, params: input_store_params
				}.to change(Store, :count).by(0)

				expect(JSON.parse(response.body)).to eq({
					"error"	=> I18n.t('store.stores.create.already_created')
				})
				expect(response).to have_http_status(:unprocessable_entity)
			end
		end
	end
	describe 'GET #index' do
		let(:user) { create(:user) }
		let(:store) { create(:store) }

		before do
			allow(Jwt::UserAuthenticator).to receive(:call).and_return(user)
		end

		context 'when user exists and has memberships' do
			before do
				create(:membership, user_id: user.id, store_id: store.id)
			end

			it 'returns the associated stores' do
				get :index, params: { id: user.id }

				expect(response).to have_http_status(:ok)
				body = JSON.parse(response.body)
				expect(body).to be_an(Array)
				expect(body.first["store_name"]).to eq(store.store_name)
			end
		end

		context 'when user does not exist' do
			it 'returns 404 user not found' do
				get :index, params: { id: 'nonexistent_id' }

				expect(response).to have_http_status(:not_found)
				expect(JSON.parse(response.body)).to eq({
					"error" => I18n.t('default.errors.messages.user_not_found'),
					"status" => "not_found"
				})
			end
		end

		context 'when user has no memberships' do
			it 'returns 404 memberships not found' do
				get :index, params: { id: user.id }

				expect(response).to have_http_status(:not_found)
				expect(JSON.parse(response.body)).to eq({
					"error" => I18n.t('user.memberships.index.failed'),
					"status" => "not_found"
				})
			end
		end
	end
end