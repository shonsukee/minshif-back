require 'rails_helper'

RSpec.describe UsersController, type: :controller do
	describe "POST #create" do
		let(:input_params) { {
			code: '',
			invitation_id: '',
			user: {
				user_name: "test",
				email: "test@gmail.com",
				picture: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYS_ocSphOFHVuKC9WgglMIvN44YC0op4uJ5rZ-qjcVhMJmwbYnudOngqiHLMTgb_kfr0"
			}
		} }

		context "when the new user create is successful" do
			before do
				allow(UserService).to receive(:create_with_token).and_return(
					success?: true,
					message: I18n.t('user.users.create.success'),
					is_affiliated: true,
					success?: :true
				)
			end

			it "render a json with new user info and created status" do
				post :create, params: input_params
				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq({
					"message"		=> I18n.t('user.users.create.success'),
					"is_affiliated"	=> true
				})
			end
		end

		context 'when response of the old user is successful' do
			before do
				allow(UserService).to receive(:create_with_token).and_return(
					success?: true,
					message: I18n.t('user.users.create.already_created'),
					is_affiliated: false,
				)
			end

			it "render a json with old user info" do
				post :create, params: input_params
				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq({
					"message"		=> I18n.t('user.users.create.already_created'),
					"is_affiliated"	=> false
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

	describe 'GET#show' do
		let(:user) { create(:user) }

		it 'when the user information is correct' do
			get :show, params: { email: user.email }

			expect(response).to have_http_status(200)
			expect(JSON.parse(response.body)).to include({
				'id' => user.id,
				'user_name' => user.user_name,
				'email' => user.email,
				'picture' => user.picture
			})
		end

		it 'returns an error when the user is not found' do
			get :show, params: { email: 'nonexistent@example.com' }

			expect(response).to have_http_status(:not_found)
			expect(JSON.parse(response.body)).to include({
				'error' => I18n.t('user.users.show.failed')
			})
		end
	end
end
