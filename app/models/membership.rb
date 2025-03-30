class Membership < ApplicationRecord
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'
	belongs_to :store, class_name: 'Store', foreign_key: 'store_id'
	has_many :shifts
	has_many :invitations

	before_save :ensure_only_one_current_store, if: :current_store_changed?

	enum :privilege, { staff: 1, manager: 2, developer: 3 }

	scope :current, -> { where(current_store: true) }
	scope :with_users, ->(user_id) { where(user_id: user_id) }
	scope :with_stores, ->(store_id) { where(store_id: store_id) }

	def self.create_with_invitation(invitation_id, user_id)
		begin
			invitation = Invitation.find_by(invitation_id: invitation_id) if invitation_id.present?
			if invitation.nil?
				raise StandardError, I18n.t('invitation.invitations.create.invalid_invitation')
			end

			manager_membership = Membership.find_by(id: invitation.membership_id)
			if manager_membership
				Membership.create!(user_id: user_id, store_id: manager_membership.store_id, current_store: true, privilege: :staff)
			else
				I18n.t('invitation.invitations.create.invalid_manager_info')
			end
		rescue StandardError => e
			e.message
		end
	end

	def self.reset_current_store(user_id)
		Membership.where(user_id: user_id, current_store: true).update_all(current_store: false)
	end

	def self.find_by_user(user)
		Membership.where(user_id: user.id)
	end

	def self.switch_store(user_id, store_id)
		reset_current_store(user_id)
		Membership.find_by(user_id: user_id, store_id: store_id)&.update(current_store: true)
	end

	private

	def ensure_only_one_current_store
		Membership.where(user_id: user_id).where.not(id: id).update_all(current_store: false)
	end
end
