class Invitation < ApplicationRecord
	belongs_to :membership, class_name: 'Membership', foreign_key: 'membership_id'

	validates :invite_link, presence: true
	validates :invitee_email, presence: true
end