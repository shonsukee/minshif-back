class Shift < ApplicationRecord
	belongs_to :membership, class_name: 'Membership', foreign_key: 'membership_id'

	has_many :shift_change_requests

	validates :shift_date, presence: true
	validates :is_registered, inclusion: { in: [true, false] }

	def self.create_preferred_shifts!(shifts, user)
		ActiveRecord::Base.transaction do
			shifts.map do |shift|
				shift.save!
			end
		end
	end
end
