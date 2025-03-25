require 'rails_helper'

RSpec.describe Membership, type: :model do
	describe 'create a new membership' do
		let(:user) { create(:user) }
		let(:store) { create(:store) }
		let!(:membership) { create(:membership, user: user, store: store, current_store: true) }

		context 'with valid attributes' do
			it 'creates a user and store membership' do
				expect(membership.user_id).to eq(user.id)
				expect(membership.store_id).to eq(store.id)
				expect(membership.current_store).to eq(true)
			end

			context 'with different store' do
				let(:new_store) { create(:store) }
				let!(:new_membership) { create(:membership, user: user, store: new_store, current_store: true) }

				it 'changes the current store' do
					expect(new_membership.user_id).to eq(user.id)
					expect(new_membership.store_id).to eq(new_store.id)
					expect(new_membership.current_store).to eq(true)
					membership.reload
					expect(membership.current_store).to eq(false)
				end
			end
		end
	end
end
