class ApplicationMailer < ActionMailer::Base
  default from: I18n.t('mailer.email.main')
  layout "mailer"
end
