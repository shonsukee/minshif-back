require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
	describe 'GET #index' do
		let(:user) { create(:user) }

		before do
			allow(Jwt::UserAuthenticator).to receive(:call).and_return(user)
		end

		context "with valid attributes" do
			context 'requested by the manager' do
				let(:store) { create(:store) }
				let!(:membership) { create(:membership, user: user, store: store, privilege: 2, current_store: true) }
				let(:shift_submission_request) { create(:shift_submission_request) }
				let!(:shift1) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-15') }
				let!(:shift2) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-20') }

				let(:params) {{
					id: user.id,
					fetch_shift: {
						start_date: Date.parse("2024-08-01"),
						end_date: Date.parse("2024-08-30"),
					}
				}}

				it "returns correct staff list" do
					get :index, params: params
					expect(response).to have_http_status(:success)

					staff_list = JSON.parse(response.body)[0]

					expect(staff_list).to be_an(Array)
					expect(staff_list.first).to include(
						'id' => 1,
						'date' => '2024-08-15',
						'start_time' => '2000-01-01T09:00:00.000+09:00',
						'end_time' => '2000-01-01T18:00:00.000+09:00',
						'email' => 'minshif.test@gmail.com',
						'notes' => 'test notes! wakuwaku.',
						'shift_submission_request_id' => 1,
						'is_registered' => false
					)
				end
			end

			context 'requested by the staff' do
				let(:store) { create(:store) }
				let!(:membership) { create(:membership, user: user, store: store, privilege: 1, current_store: true) }
				let(:shift_submission_request) { create(:shift_submission_request) }
				let!(:shift1) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-15') }
				let!(:shift2) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-20') }

				let(:params) {{
					id: user.id,
					fetch_shift: {
						start_date: Date.parse("2024-08-01"),
						end_date: Date.parse("2024-08-30"),
					}
				}}

				it "returns nil staff list" do
					get :index, params: params
					expect(response).to have_http_status(:success)

					staff_list = JSON.parse(response.body)[0]

					expect(staff_list).to be_an(Array)
					expect(staff_list.first).to be_nil
				end
			end
		end

		context "with invalid attributes" do
			let(:params) {{
				id: "",
				fetch_shift: {
					start_date: Date.parse("2024-08-01"),
					end_date: Date.parse("2024-08-30"),
				}
			}}

			it "returns id missing error" do
				get :index, params: params

				expect(JSON.parse(response.body)).to eq({
					"error" => I18n.t('default.errors.messages.id_blank')
				})
				expect(response).to have_http_status(:bad_request)
			end

			it "returns user not found error" do
				params[:id] = "invalid_id"
				get :index, params: params

				expect(JSON.parse(response.body)).to eq({
					"error" => I18n.t('default.errors.messages.user_not_found')
				})
				expect(response).to have_http_status(:not_found)
			end

			it "returns store not found error" do
				allow(Membership).to receive(:find_by).and_return(nil)
				params[:id] = user.id
				get :index, params: params

				expect(JSON.parse(response.body)).to eq({
					"error" => I18n.t('default.errors.messages.store_not_found')
				})
				expect(response).to have_http_status(:not_found)
			end
		end
	end
end