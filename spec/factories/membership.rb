FactoryBot.define do
	factory :membership do
		association :user
		association :store
		current_store { true }
		calendar_id { "" }
		privilege { 1 }
	end
end
