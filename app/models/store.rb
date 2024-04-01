class Store < ApplicationRecord
	include IdGenerator

	validates :store_name, presence: true
end
