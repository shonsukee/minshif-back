FactoryBot.define do
	factory :user, aliases: [:owner] do
		sequence(:user_name) { |n| "minshif Test User #{n}" }
		sequence(:email) { |n| "minshif#{n}@gmail.com" }
		picture { "https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw" }
	end
end
