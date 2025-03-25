FactoryBot.define do
	factory :shift do
		association :membership, factory: :membership
		association :shift_submission_request, factory: :shift_submission_request
		shift_date { '2024-08-02' }
		start_time { '09:00:00' }
		end_time { '18:00:00' }
		notes { 'test notes! wakuwaku.' }
		is_registered { false }
	end
end
