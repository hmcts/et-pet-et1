module SaveAndReturn
  class Mailer < ::Devise::Mailer
    self.deliver_later_queue_name = :mailers

  end
end
