class UserService
	def self.create_with_token(input_params)
		invitation_id = input_params[:invitation_id] || nil

		user = User.find_or_initialize_by(email: input_params[:user][:email])

		# 既存ユーザの場合
		if user.persisted?
			# 店舗に所属しているか
			is_affiliated = Membership.current.with_users(user.id).count > 0
			{ success?: true, message: I18n.t('user.users.create.already_created'), is_affiliated: is_affiliated }
		else
			# ユーザの保存
			if user.update(input_params[:user])
				begin
					Membership.create_with_invitation(invitation_id[:invitation_id], user.id) if invitation_id[:invitation_id].present?
					# 店舗に所属しているか
					is_affiliated = Membership.current.with_users(user.id).count > 0
					{ success?: true, message: I18n.t('user.users.create.success'), is_affiliated: is_affiliated }
				rescue StandardError => e
					{ success?: false, error: e }
				end
			else
				{ success?: false, error: user.errors.full_messages }
			end
		end
	end
end
