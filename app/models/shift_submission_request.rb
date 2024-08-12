class ShiftSubmissionRequest < ApplicationRecord
	belongs_to :store

	has_many :shifts

	validates :start_date, presence: true
	validates :end_date, presence: true
	validate :date_cannot_be_in_the_past
	validate :start_date_is_less_than_end_date
	validate :deadline_is_less_than_start_date

	scope :wanted, ->(store_id) { where('store_id = ? AND deadline_date >= ?',  store_id, Date.today) }

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
