class Template < ApplicationRecord
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'

	validates :user_id, presence: true
	validates :start_time, presence: true
	validates :end_time, presence: true
end
