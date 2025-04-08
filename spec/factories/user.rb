FactoryBot.define do
	factory :user do
		user_name { "minshif_test_user" }
		email { I18n.t('mailer.email.test') }
		picture { "https://play-lh.googleusercontent.com/ZyWNGIfzUyoajtFcD7NhMksHEZh37f-MkHVGr5Yfefa-IX7yj9SMfI82Z7a2wpdKCA=w240-h480-rw" }
	end
end
