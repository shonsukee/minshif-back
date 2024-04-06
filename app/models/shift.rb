class Shift < ApplicationRecord
	belongs_to :membership, class_name: 'Membership', foreign_key: 'membership_id'

	has_many :shift_change_requests

	validates :shift_date, presence: true
	validates :is_registered, inclusion: { in: [true, false] }
end
