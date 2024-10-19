class Store < ApplicationRecord
	include IdGenerator

	has_many :memberships
	has_many :business_hours
	has_many :shift_submission_requests
	has_many :special_business_hours

	validates :store_name, presence: true
end
