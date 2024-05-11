require 'rails_helper'

RSpec.describe User::UsersController, type: :controller do
	describe "POST #create" do
		let(:input_params) { { code: 'sample_code' } }

		context "when the new user create is successful" do
			before do
				allow(UserService).to receive(:create_with_token).and_return(
					success?: true,
					msg: I18n.t('user.users.create.success'),
					token: 'sample_token',
					user_id: '1',
					is_new_user: true,
					status: :created
				)
			end

			it "render a json with new user info and created status" do
				post :create, params: input_params
				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq({
					"msg"			=> I18n.t('user.users.create.success'),
					"token"			=> "sample_token",
					"user_id"		=> "1",
					"is_new_user"	=> true
				})
			end
		end

		context 'when response of the old user is successful' do
			before do
				allow(UserService).to receive(:create_with_token).and_return(
					success?: true,
					msg: I18n.t('user.users.create.already_created'),
					token: 'sample_token',
					user_id: '1',
					is_new_user: false,
					status: :ok
				)
			end

			it "render a json with old user info" do
				post :create, params: input_params
				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq({
					"msg"			=> I18n.t('user.users.create.already_created'),
					"token"			=> "sample_token",
					"user_id"		=> "1",
					"is_new_user"	=> false
				})
			end
		end

		context "when the user creation fails" do
			before do
				allow(UserService).to receive(:create_with_token).and_return(
					success?: false,
					error: "Failed to create user",
					status: :unprocessable_entity
				)
			end

			it 'renders an error json with unprocessable_entity status' do
				post :create, params: input_params
				expect(response).to have_http_status(:unprocessable_entity)
				expect(JSON.parse(response.body)).to eq({
					'error' => 'Failed to create user'
				})
			end
		end
	end
end
