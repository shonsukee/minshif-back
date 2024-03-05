class Store < ApplicationRecord
	validates :manager_id, presence: true
	validates :store_name, presence: true
end
