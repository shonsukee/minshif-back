class ShiftSubmissionRequest < ApplicationRecord
	belongs_to :store

	has_many :shifts

	validates :start_date, presence: true
	validates :end_date, presence: true
	validate :date_cannot_be_in_the_past
	validate :start_date_is_less_than_end_date
	validate :deadline_is_less_than_start_date

	scope :wanted, ->(membership) {
		where('store_id = ? AND deadline_date >= ?', membership.store_id, Date.today)
		.where.not(id: Shift.where(membership_id: membership.id).where.not(shift_submission_request_id: nil).select(:shift_submission_request_id))
	}


	private

	def date_cannot_be_in_the_past
		if start_date.present? && start_date < Date.today
			errors.add(:start_date, I18n.t("default.errors.past_date"))
		end

		if end_date.present? && end_date < Date.today
			errors.add(:end_date, I18n.t("default.errors.past_date"))
		end
	end

	def start_date_is_less_than_end_date
		if start_date.present? && end_date.present? && start_date > end_date
			errors.add(:start_date, I18n.t("default.errors.start_date_after_end_date"))
		end
	end

	def deadline_is_less_than_start_date
		if deadline_date.present? && start_date.present? && deadline_date > start_date
			errors.add(:start_date, I18n.t("default.errors.deadline_date_after_end_date"))
		end
	end
end
