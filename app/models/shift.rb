class Shift < ApplicationRecord
	belongs_to :membership, class_name: 'Membership', foreign_key: 'membership_id'
	belongs_to :shift_submission_request, optional: true, foreign_key: 'shift_submission_request_id'

	has_many :shift_change_requests

	validates :shift_date, presence: true
	validates :is_registered, inclusion: { in: [true, false] }

	scope :with_id, ->(id) { where(id: id) }
	scope :registered_shift_for_date, ->(membership_id, shift_date) { where(membership_id: membership_id, shift_date: shift_date, is_registered: true) }

	def self.register_draft_shifts!(shifts_params, current_user)
		register_shifts!(shifts_params, current_user, true)
	end

	def self.register_preferred_shifts!(shifts_params, current_user)
		register_shifts!(shifts_params, current_user, false)
	end

	private

	def self.register_shifts!(shifts_params, current_user, is_draft_shifts)
		ActiveRecord::Base.transaction do
			shifts_params.each do |shift_params|
				membership_id = find_membership_id(shift_params, current_user, is_draft_shifts)
				raise ActiveRecord::RecordInvalid.new("Membership not found") if membership_id.nil?

				shift = build_shift(shift_params, membership_id)
				validate_shift!(shift, shift_params[:shift_submission_request_id])

				# シフトが既に登録済みなら更新
				registered_shift = registered_shift_for_date(shift.membership_id, shift.shift_date).first
				if registered_shift.present?
					registered_shift.update!(
						start_time: shift.start_time,
						end_time: shift.end_time,
						notes: shift.notes,
						is_registered: shift.is_registered,
						shift_submission_request_id: shift.shift_submission_request_id
					)
				else
					shift.save!
				end
			end
		end
	end

	def self.find_membership_id(shift_params, current_user, is_draft_shifts)
		if is_draft_shifts
			shift = Shift.with_id(shift_params[:id]).first
			return shift.membership_id if shift.present?

			# 希望シフトがない日付からの登録時にユーザ名で検索
			user = User.find_by(user_name: shift_params[:user_name])
			raise ActiveRecord::RecordInvalid.new("User not found") if user.nil?

			membership = Membership.where(user_id: user.id, store_id: current_user.memberships.current.first.store_id).first
			return membership.id if membership.present?

			raise ActiveRecord::RecordInvalid.new("Membership not found")
		else
			current_user.memberships.current.first.id
		end
	end

	def self.build_shift(shift_params, membership_id)
		Shift.new(
			membership_id: membership_id,
			shift_submission_request_id: shift_params[:shift_submission_request_id],
			shift_date: shift_params[:date],
			start_time: shift_params[:start_time],
			end_time: shift_params[:end_time],
			notes: shift_params[:notes],
			is_registered: shift_params[:is_registered]
		)
	end

	def self.validate_shift!(shift, shift_submission_request_id)
		validator = ShiftValidator.new(shift, shift_submission_request_id)
		validator.validate
	end
end
