FactoryBot.define do
	factory :preferred_shift do
		association :membership
		shift_date { Date.new(2024, 10, 10) }
		start_time { Time.parse('09:00:00') }
		end_time { Time.parse('18:00:00') }
		notes { "" }
		is_registered { false }
	end
end
