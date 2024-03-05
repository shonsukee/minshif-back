class Membership < ApplicationRecord
	belongs_to :user, class_name: 'User', foreign_key: 'user_id'
	belongs_to :store, class_name: 'Store', foreign_key: 'store_id'

end
