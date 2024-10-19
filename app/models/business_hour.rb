class BusinessHour < ApplicationRecord
	belongs_to :store, class_name: 'Store', foreign_key: 'store_id'

	validates :store_id, presence: true
	validates :day_of_week, length: { is: 1 }, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 7 }
end
