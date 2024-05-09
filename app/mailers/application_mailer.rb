class ApplicationMailer < ActionMailer::Base
  default from: I18n.t('user_mailer.email.main')
  layout "mailer"
end
