require_relative './base_page'
module ET1
  module Test
    class StepEightPage < BasePage

      section :claim_type, :xpath, (XPath.generate { |x| x.descendant(:div)[x.child(:h2)[x.string.n.is("What your claim is about")]] }) do
        def set(value)
          check value
        end
      end

      section :whistleblowing_claim, :xpath, (XPath.generate { |x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Whistleblowing claim")]] }) do
        def set(value)
          choose value, name: "claim_type[is_whistleblowing]"
        end
        section :send_to_relevant_person, '.claim_type_send_claim_to_whistleblowing_entity' do
          def set(value)
            choose value, name: "claim_type[send_claim_to_whistleblowing_entity]"
          end
        end
      end

      element :save_and_continue, 'form.edit_claim_type input[value="Save and continue"]'
    end

  end
end
