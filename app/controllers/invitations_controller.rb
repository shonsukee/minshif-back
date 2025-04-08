class InvitationsController < ApplicationController
	def create
		if params[:invitee_email].blank?
			render json: { error: I18n.t('invitation.invitations.create.blank') }, status: :bad_request
			return
		end

		# 管理者情報
		@manager = User.find_by(id: params[:manager_id])
		membership = Membership.find_by(user_id: @manager.id, current_store: true)
		if membership.blank? || @manager.blank?
			render json: { error: I18n.t('invitation.invitations.create.invalid_manager_info') }, status: :bad_request
			return
		end

		ActiveRecord::Base.transaction do
			invitee_email = params[:invitee_email].downcase
			@invitee_user = User.find_by(email: invitee_email)

			# 招待しているグループに既に所属している場合
			if @invitee_user && Membership.find_by(user_id: @invitee_user.id, store_id: membership.store_id)
				render json: { message: I18n.t('invitation.invitations.create.already_joined') }
			elsif @invitee_user
				begin
					# 既存ユーザで，招待している店舗に参加していない場合，スタッフとして店舗に追加
					Membership.create!(
						user_id: @invitee_user.id,
						store_id: membership.store_id,
						current_store: false,
						privilege: 1
					)
					render json: { message: I18n.t('invitation.invitations.create.success') }
				rescue StandardError => e
					render json: { error: e.message }
				end
			else
				# マジックリンク生成
				secure_id = SecureRandom.urlsafe_base64
				@invite_link = "#{ENV['FRONTEND_ORIGIN']}/signin?invitation_id=#{secure_id}"
				@invitee_user = User.new(
					user_name: "guest",
					email: invitee_email
				)

				begin
					@invitee_user.send_invite_email(@invitee_user, @invite_link, @manager)
					Invitation.create!(
						membership_id: membership.id,
						invitation_id: secure_id,
						invitee_email: invitee_email,
						expired_at: DateTime.now + 1.day
					)
					render json: { message: I18n.t('invitation.invitations.create.success_invited') }
				rescue StandardError => e
					render json: { error: e.message }
				end
			end
		rescue StandardError => e
			render json: { error: I18n.t('invitation.invitations.create.failed'), error_message: e.message }, status: :unprocessable_entity
		end
	end
end