FactoryBot.define do
	factory :store do
		sequence(:store_name) { |n| "スーパーspec#{n}号店" }
		location { '東京都渋谷区' }
	end
end