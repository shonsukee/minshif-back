class User < ApplicationRecord
	validates :user_name, presence: true, length: {maximum: 20}
end
