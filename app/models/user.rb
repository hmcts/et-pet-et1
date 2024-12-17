class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable

  belongs_to :claim, foreign_key: :reference, primary_key: :application_reference, optional: false

  validates :email, email: { mode: :strict }, allow_blank: true
  validates :password, presence: true, on: :create
  after_commit :send_pending_devise_notifications

  def validate_after_login
    claim_not_submitted
  end

  # As we allow multiple users with same email address - we always find the last one instead of the first
  def self.find_first_by_auth_conditions(tainted_conditions, opts = {})
    to_adapter.find_all(devise_parameter_filter.filter(tainted_conditions).merge(opts)).last
  end

  protected

  def send_devise_notification(notification, *args)
    if new_record? || changed?
      pending_devise_notifications << [notification, args]
    else
      render_and_send_devise_message(notification, *args)
    end
  end

  private

  def claim_not_submitted
    return unless claim.immutable?

    errors.add(:base, I18n.t('errors.user_session.immutable'))
  end

  def send_pending_devise_notifications
    pending_devise_notifications.each do |notification, args|
      render_and_send_devise_message(notification, *args)
    end

    # Empty the pending notifications array because the
    # after_commit hook can be called multiple times which
    # could cause multiple emails to be sent.
    pending_devise_notifications.clear
  end

  def pending_devise_notifications
    @pending_devise_notifications ||= []
  end

  def render_and_send_devise_message(notification, *)
    message = devise_mailer.send(notification, self, *)

    if message.respond_to?(:deliver_later)
      message.deliver_later
    elsif message.respond_to?(:deliver_now)
      message.deliver_now
    else
      message.deliver
    end
  end
end
