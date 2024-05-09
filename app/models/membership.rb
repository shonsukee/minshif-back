class Membership < ApplicationRecord
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'
	belongs_to :store, class_name: 'Store', foreign_key: 'store_id'

	has_many :shifts
	has_many :invitations

	enum :status, { stuff: 1, manager: 2, developer: 3 }

	scope :current, -> { where(current_store: true) }

	def self.create_with_invitation(invitation_id, user_id)
		begin
			invitation = Invitation.find_by(invitation_id: invitation_id) if invitation_id.present?
			if invitation.nil?
				raise StandardError, I18n.t('invitation.invitations.create.invalid_invitation')
			end

			manager_membership = Membership.find_by(id: invitation.membership_id)
			if manager_membership
				Membership.create!(user_id: user_id, store_id: manager_membership.store_id, current_store: true, privilege: 1)
			else
				I18n.t('invitation.invitations.create.invalid_manager_info')
			end
		rescue StandardError => e
			e.message
		end
	end
end
