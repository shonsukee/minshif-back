class ShiftChangeRequest < ApplicationRecord
	belongs_to :shift, class_name: 'Shift', foreign_key: 'shift_id'

	validates :store_id, presence: true
	validates :requestor, presence: true
	validates :status, inclusion: { in: %w(searching approved denied) }
end
