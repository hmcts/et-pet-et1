require_relative './base_page'
module ET1
  module Test
    class StepNinePage < BasePage

      element :description, 'textarea[name="claim_details[claim_details]"]'
      section :similar_claims, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Similar claims")]] }) do
        section :other_claimants, '.claim_details_other_known_claimants' do
          def set(value)
            choose value, name: "claim_details[other_known_claimants]"
          end
        end
        element :names, 'textarea[name="claim_details[other_known_claimant_names]"]'
      end

      element :save_and_continue, 'form.edit_claim_details input[value="Save and continue"]'
    end

  end
end
