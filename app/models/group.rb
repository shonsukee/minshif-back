class Group < ApplicationRecord
	encrypts :group_name, deterministic: true, downcase: true
end
