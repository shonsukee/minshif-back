class InvitationsController < ApplicationController
	def create
		if params[:invitee][:email].blank?
			render json: { error: "メールアドレスを入力してください。" }, status: :bad_request
			return
		end

		# 管理者情報
		@manager = User.find_by(id: params[:manager][:user_id])
		membership = Membership.find_by(user_id: @manager.id, current_store: true)
		if membership.blank? || @manager.blank?
			render json: { error: "管理者情報が不正です。" }, status: :bad_request
			return
		end

		ActiveRecord::Base.transaction do
			invitee_email = params[:invitee][:email].downcase
			@invitee_user = User.find_or_initialize_by(email: invitee_email) do |new_user|
				new_user.user_name = "名無しの権兵衛"
				new_user.picture = ""
			end

			# 招待しているグループに既に所属している場合
			if @invitee_user && Membership.find_by(user_id: @invitee_user.id, store_id: membership.store_id)
				render json: { error: "そのメールアドレスは所属済みです。" }
			else
				# マジックリンク生成
				secure_code = SecureRandom.urlsafe_base64
				@invite_link = "#{ENV['FRONTEND_ORIGIN']}/login?code=#{secure_code}"

				begin
					@invitee_user.send_invite_email(@invitee_user, @invite_link, @manager)
					Invitation.create!(
						membership_id: membership.id,
						invite_link: @invite_link,
						invitee_email: invitee_email,
						expired_at: DateTime.now + 1.day
					)
					render json: { response: "招待メール送信完了！" }
				rescue StandardError => e
					render json: { error: e.message }
				end
			end
		rescue StandardError => e
			render json: { error: "招待作成に失敗しました: #{e.message}" }, status: :unprocessable_entity
		end
	end
end