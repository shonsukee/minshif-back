require 'rails_helper'

RSpec.describe Store::StoreController, type: :controller do
	describe 'POST #create' do
		let(:input_store_params) {{
			store: {
				store_name: store_name,
				location: '木ノ葉隠れの里',
			}
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
				Store.create!(input_store_params[:store])
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

	describe 'GET #fetch_staff_list' do
		let(:user) { create(:user) }

		before do
			allow(Jwt::UserAuthenticator).to receive(:call).and_return(user)
		end

		context "with valid attributes" do
			let(:store) { create(:store) }
			let!(:membership) { create(:membership, user: user, store: store, current_store: true) }

			it "returns correct staff list" do
				get :fetch_staff_list, params: { email: user.email }
				expect(response).to have_http_status(:success)
				staff_list = JSON.parse(response.body)['staff_list']

				expect(staff_list).to be_an(Array)
				expect(staff_list.first).to include(
					'id' => membership.id,
					'user_name' => user.user_name,
					'privilege' => 'staff'
				)
			end
		end

		context "with invalid attributes" do
			it "returns error when user is not logged in to the shop" do
				get :fetch_staff_list, params: { email: user.email }

				expect(JSON.parse(response.body)).to eq({
					"error"	=> I18n.t('store.stores.fetch_staff_list.not_found')
				})
				expect(response).to have_http_status(:not_found)
			end
		end
	end
end