require 'rails_helper'

RSpec.describe Shift::ShiftsController, type: :controller do
	describe 'GET #fetch_shifts' do
		let(:user) { create(:user) }

		before do
			allow(Jwt::UserAuthenticator).to receive(:call).and_return(user)
		end

		context "with valid attributes" do
			context 'requested by the manager' do
				let(:store) { create(:store) }
				let!(:membership) { create(:membership, user: user, store: store, privilege: 2) }
				let(:shift_submission_request) { create(:shift_submission_request) }
				let!(:shift1) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-15') }
				let!(:shift2) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-20') }

				let(:params) {{
					fetch_shift: {
						start_date: Date.parse("2024-08-01"),
						end_date: Date.parse("2024-08-30"),
					}
				}}

				it "return correct staff list" do
					get :fetch_shifts, params: params
					expect(response).to have_http_status(:success)

					staff_list = JSON.parse(response.body)['staff_shift_list'][0]

					expect(staff_list).to be_an(Array)
					expect(staff_list.first).to include(
						'date' => '2024-08-15',
						"start_time"=>"2000-01-01T09:00:00.000+09:00",
						"end_time"=>"2000-01-01T18:00:00.000+09:00",
						'user_name' => user.user_name,
						'is_registered'=>false
					)
				end
			end

			context 'requested by the staff' do
				let(:store) { create(:store) }
				let!(:membership) { create(:membership, user: user, store: store, privilege: 1) }
				let(:shift_submission_request) { create(:shift_submission_request) }
				let!(:shift1) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-15') }
				let!(:shift2) { create(:shift, membership: membership, shift_submission_request: shift_submission_request, shift_date: '2024-08-20') }

				let(:params) {{
					fetch_shift: {
						start_date: Date.parse("2024-08-01"),
						end_date: Date.parse("2024-08-30"),
					}
				}}

				it "return nil staff list" do
					get :fetch_shifts, params: params
					expect(response).to have_http_status(:success)

					staff_list = JSON.parse(response.body)['staff_shift_list'][0]

					expect(staff_list).to be_an(Array)
					expect(staff_list.first).to be nil
				end
			end
		end

		context "with invalid attributes" do
			let(:params) {{
				fetch_shift: {
					start_date: Date.parse("2024-08-01"),
					end_date: Date.parse("2024-08-30"),
				}
			}}

			it "had not logged in to the shop" do
				get :fetch_shifts, params: params

				expect(JSON.parse(response.body)).to eq({
					"error"	=> I18n.t('shift.shifts.fetch_shifts.login_required')
				})
				expect(response).to have_http_status(:not_found)
			end
		end
	end
end