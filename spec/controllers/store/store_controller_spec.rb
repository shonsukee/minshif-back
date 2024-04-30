require 'rails_helper'

describe Store::StoreController, type: :controller do
	describe 'POST #create' do
		let(:attributes) {{
			store: {
				store_name: store_name,
				location: '木ノ葉隠れの里',
			}
		}}

		before(:each) do
			allow(controller).to receive(:authenticate).and_return(true)
			@current_user = FactoryBot.create(:user)
			# allow(controller).to receive(:@current_user).and_return(@current_user)
			allow_any_instance_of(Store::StoreController).to receive(:current_user).and_return(@current_user)
		end

		context "with valid attributes" do
			let(:store_name) { "ラーメン一楽" }
			it "creates a new Store" do
				expect {
					post :create, params: attributes
				}.to change(Store, :count).by(1)
			end

			it "renders a JSON response with the new store" do
				post :create, params: attributes
				expect(response).to be_successful
				expect(response.content_type).to include('application/json')
			end
		end

		context "with invalid attributes" do
			let(:store_name) { "" }
			it "does not create a new Store" do
				expect {
					post :create, params: attributes
				}.to change(Store, :count).by(0)
			end

			it "renders a JSON response with errors for the new store" do
				post :create, params: attributes
				expect(response).to have_http_status(:unprocessable_entity)
				expect(response.content_type).to include('application/json')
				expect(response.body).to include(I18n.t('store.stores.create.empty'))
			end
		end

		context "when store already exists" do
			let(:store_name) { "ラーメン一楽" }
			before do
				Store.create!(attributes[:store])
			end

			it "does not allow duplicate store names" do
				expect {
					post :create, params: attributes
				}.to change(Store, :count).by(0)
			end

			it "returns an error message" do
				post :create, params: attributes
				expect(response).to have_http_status(:unprocessable_entity)
				expect(response.content_type).to include('application/json')
				expect(response.body).to include(I18n.t('store.stores.create.already_created'))
			end
		end
	end
end