class UserService
	def self.create_with_token(input_token_params, invitation_id = nil)
		# GoogleAccessToken取得
		token_service = TokenService.new(input_token_params)
		token_params = token_service.get_token

		return { success?: false, error: token_params[:error] } if token_params[:error].present?

		@token = Token.new(
			refresh_token: token_params[:refresh_token],
			access_token: token_params[:access_token]
		)

		# Googleアカウント情報取得
		user_params = Google::GoogleService.fetch_user_info(@token.access_token)
		return { success?: false, error: user_params[:error] } if user_params[:error].present?

		user = User.find_or_initialize_by(email: user_params[:email])

		# 店舗に所属していないユーザ
		is_new_user = true

		# 既存ユーザの場合
		if user.persisted?
			user.update_access_token(@token.access_token)
			memberships = Membership.current.with_users(user.id)
			is_new_user = false if memberships.count > 0
			token = Jwt::TokenProvider.call(user.id)
			{ success?: true, msg: I18n.t('user.users.create.already_created'), token: token, user_id: user.id, is_new_user: is_new_user }
		else
			# ユーザの保存とJWTトークンの生成
			if user.update(user_params)
				begin
					Membership.create_with_invitation(invitation_id[:invitation_id], user.id) if invitation_id[:invitation_id].present?
					memberships = Membership.current.with_users(user.id)
					is_new_user = false if memberships.count > 0
					user.create_token(@token.refresh_token, @token.access_token)
					token = Jwt::TokenProvider.call(user.id)
					{ success?: true, msg: I18n.t('user.users.create.success'), token: token, user_id: user.id, is_new_user: is_new_user }
				rescue StandardError => e
					{ success?: false, error: e }
				end
			else
				{ success?: false, error: user.errors.full_messages }
			end
		end
	end
end
