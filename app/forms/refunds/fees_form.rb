module Refunds
  class FeesForm < Form
    PAYMENT_METHODS = ['card', 'cheque', 'cash']
    attribute :et_issue_fee,                            Float
    attribute :et_issue_fee_payment_method,             String
    attribute :et_hearing_fee,                          Float
    attribute :et_hearing_fee_payment_method,           String
    attribute :eat_issue_fee,                           Float
    attribute :eat_issue_fee_payment_method,            String
    attribute :eat_hearing_fee,                         Float
    attribute :eat_hearing_fee_payment_method,          String
    attribute :et_reconsideration_fee,                 Float
    attribute :et_reconsideration_fee_payment_method,  String

    validates :et_issue_fee, :et_hearing_fee, :et_reconsideration_fee, :eat_issue_fee, :eat_hearing_fee, numericality: true, allow_blank: true
    validates :et_issue_fee_payment_method, presence: true, if: -> (obj) { obj.et_issue_fee.present? && obj.et_issue_fee > 0 }
    validates :et_hearing_fee_payment_method, presence: true, if: -> (obj) { obj.et_hearing_fee.present? && obj.et_hearing_fee > 0}
    validates :et_reconsideration_fee_payment_method, presence: true, if: -> (obj) { obj.et_reconsideration_fee.present? && obj.et_reconsideration_fee > 0 }
    validates :eat_issue_fee_payment_method, presence: true, if: -> (obj) { obj.eat_issue_fee.present? && obj.eat_issue_fee > 0 }
    validates :eat_hearing_fee_payment_method, presence: true, if: -> (obj) { obj.eat_hearing_fee.present? && obj.eat_hearing_fee > 0}

    def et_issue_fee
      val = super
      return val if val.nil?
      val.to_f / 100
    end

    def et_issue_fee=(val)
      return super if val.nil?
      super((val.to_f * 100).to_i)
    end

  end
end
