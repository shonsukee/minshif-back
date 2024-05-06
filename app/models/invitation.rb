class Invitation < ApplicationRecord
	belongs_to :membership, class_name: 'Membership', foreign_key: 'membership_id'

	validates :invitation_id, presence: true
	validates :invitee_email, presence: true
end