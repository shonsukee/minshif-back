require 'rails_helper'

RSpec.describe "Memberships", type: :request do
	describe "GET /memberships" do
		let(:user) { create(:user, email: "test@example.com") }

		context "when the user does not exist" do
			it "returns 404 and error message" do
				get '/users/memberships', params: { email: "notfound@example.com" }

				expect(response).to have_http_status(:not_found)
				expect(JSON.parse(response.body)["error"]).to eq(I18n.t('user.memberships.index.failed'))
			end
		end

		context "when the membership does not exist" do
			it "returns 404 and error message" do
				get '/users/memberships', params: { email: user.email }

				expect(response).to have_http_status(:not_found)
				expect(JSON.parse(response.body)["error"]).to eq(I18n.t('user.memberships.index.failed'))
			end
		end

		context "when the membership exists" do
			let(:store) { create(:store) }
			let!(:membership) { create(:membership, user: user, store: store, current_store: true) }

			before do
				allow(Membership).to receive_message_chain(:with_users, :current, :first).and_return(membership)
			end

			it "returns membership information" do
				get '/users/memberships', params: { email: user.email }

				expect(response).to have_http_status(:ok)
				json = JSON.parse(response.body)

				expect(json["membership"]).to include(
					"id" => membership.id,
					"user_id" => membership.user_id,
					"store_id" => membership.store_id,
					"current_store" => membership.current_store,
					"calendar_id" => membership.calendar_id,
					"privilege" => membership.privilege
				)
			end
		end
	end
end
