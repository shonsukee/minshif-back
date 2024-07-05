FactoryBot.define do
	factory :membership do
		association :user, factory: :user
		association :store, factory: :store
		current_store { true }
		calendar_id { "" }
		privilege { 1 }
	end
end
