Sentry.init do |config|
	config.dsn = ENV['SENTRY_DSN']
	config.breadcrumbs_logger = [:active_support_logger, :http_logger]

	# Add data like request headers and IP for users,
	# see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
	config.send_default_pii = !Rails.env.production?
end