FactoryBot.define do
	factory :shift_submission_request do
		association :store
		start_date { Date.new(2026, 01, 01) }
		end_date { Date.new(2026, 01, 31) }
		deadline_date { Date.new(2025, 12, 25) }
		deadline_time { "00:00" }
		notes { "This is a bot." }
	end
end
