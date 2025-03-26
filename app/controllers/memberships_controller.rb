class MembershipsController < ApplicationController
	def index
		user = User.find_by(email: params[:email])
		if user.nil?
			render json: { error: I18n.t('user.memberships.index.failed') }, status: :not_found
			return
		end

		membership = Membership.with_users(user[:id]).current.first
		if membership.nil?
			render json: { error: I18n.t('user.memberships.index.failed') }, status: :not_found
		else
			render json: {
				membership: {
					id: membership[:id],
					user_id: membership[:user_id],
					store_id: membership[:store_id],
					current_store: membership[:current_store],
					calendar_id: membership[:calendar_id],
					privilege: membership[:privilege],
				}
			}
		end
	end
end
