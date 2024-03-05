class Shift < ApplicationRecord
	belongs_to :membership, class_name: 'Membership', foreign_key: 'membership_id'

	validates :shift_date, presence: true
	validates :is_registered, inclusion: { in: [true, false] }
end
