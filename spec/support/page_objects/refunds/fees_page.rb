require_relative './sections/simple_form'
module ET1
  module Test
    module Refunds
      class FeesPage < BasePage
        element :form_error_message, '[aria-describedby=error-message]'
        element :help, '[data-behavior=help]'
        section :original_claim_fees, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Complete the relevant fields for fees you have paid")]] }) do
          section :et_issue, :xpath, (XPath.generate { |x| x.descendant(:tr)[x.descendant(:td)[x.string.n.is("ET Issue")]] }) do
            section :fee, ET1::Test::RefundSections::FormInput, '.refunds_fees_et_issue_fee'
            section :payment_date, ET1::Test::RefundSections::FormPaymentDate, '.refunds_fees_et_issue_fee_payment_date'
            section :payment_method, ET1::Test::RefundSections::FormSelect, '.refunds_fees_et_issue_fee_payment_method'
          end
          section :et_hearing, :xpath, (XPath.generate { |x| x.descendant(:tr)[x.descendant(:td)[x.string.n.is("ET Hearing")]] }) do
            section :fee, ET1::Test::RefundSections::FormInput, '.refunds_fees_et_hearing_fee'
            section :payment_date, ET1::Test::RefundSections::FormPaymentDate, '.refunds_fees_et_hearing_fee_payment_date'
            section :payment_method, ET1::Test::RefundSections::FormSelect, '.refunds_fees_et_hearing_fee_payment_method'
          end
          section :et_reconsideration, :xpath, (XPath.generate { |x| x.descendant(:tr)[x.descendant(:td)[x.string.n.is("ET Reconsideration")]] }) do
            section :fee, ET1::Test::RefundSections::FormInput, '.refunds_fees_et_reconsideration_fee'
            section :payment_date, ET1::Test::RefundSections::FormPaymentDate, '.refunds_fees_et_reconsideration_fee_payment_date'
            section :payment_method, ET1::Test::RefundSections::FormSelect, '.refunds_fees_et_reconsideration_fee_payment_method'
          end
          section :eat_issue, :xpath, (XPath.generate { |x| x.descendant(:tr)[x.descendant(:td)[x.string.n.is("EAT Issue")]] }) do
            section :fee, ET1::Test::RefundSections::FormInput, '.refunds_fees_eat_issue_fee'
            section :payment_date, ET1::Test::RefundSections::FormPaymentDate, '.refunds_fees_eat_issue_fee_payment_date'
            section :payment_method, ET1::Test::RefundSections::FormSelect, '.refunds_fees_eat_issue_fee_payment_method'
          end
          section :eat_hearing, :xpath, (XPath.generate { |x| x.descendant(:tr)[x.descendant(:td)[x.string.n.is("EAT Hearing")]] }) do
            section :fee, ET1::Test::RefundSections::FormInput, '.refunds_fees_eat_hearing_fee'
            section :payment_date, ET1::Test::RefundSections::FormPaymentDate, '.refunds_fees_eat_hearing_fee_payment_date'
            section :payment_method, ET1::Test::RefundSections::FormSelect, '.refunds_fees_eat_hearing_fee_payment_method'
          end
          section :total, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Total fees paid")]] }) do
            element :fee, '[data-behavior=\'total_fees\']'
          end
        end

        def has_valid_help_section?
          messages = [
            "Fees were charged in the Employment Tribunal and Employment Appeals Tribunal between 29 July 2013 and 26 July 2017",
            "A type A claim had an issue fee of £160 and a hearing fee of £230.",
            "A type B claim had an issue fee of £250 and a hearing fee of £950.",
            "An Employment Appeal Tribunal fee had a lodgement fee of £400 and a hearing fee of £1200."
          ]
          help.assert_text(messages.join("\n"))
        end

        element :save_and_continue, 'form.edit_refunds_fees input[value="Continue"]'
      end
    end

  end
end
