class SpecialBusinessHour < ApplicationRecord
	belongs_to :store, class_name: 'Store', foreign_key: 'store_id'

	validates :special_date, presence: true
	validates :open_time, presence: true
	validates :close_time, presence: true
end
