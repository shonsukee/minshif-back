class Store < ApplicationRecord
	include IdGenerator

	has_many :memberships
	has_many :business_hours
	has_many :shift_submission_requests
	has_many :special_business_hours

	validates :store_name, presence: true

	def self.find_by_memberships(memberships)
		store_ids = memberships.map(&:store_id)
		stores = Store.where(id: store_ids).index_by(&:id)

		memberships.map do |membership|
			{
				store_name: stores[membership.store_id]&.store_name,
				current_store: membership.current_store
			}
		end
	end
end
