class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  self.deliver_later_queue_name = :mailers
end
