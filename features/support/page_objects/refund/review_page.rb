module Refunds
  class ReviewPage < BasePage
    section :about_the_claimant, :refund_review_section_labelled, 'Current Claimants Details' do
      element :full_name, :refund_review_section_field_labelled, 'Full Name'
      element :date_of_birth, :refund_review_section_field_labelled, 'Date Of Birth'
    end
    section :claimants_contact_details, :refund_review_section_labelled, 'Contact Details' do
      element :building, :refund_review_section_field_labelled, 'Building number or name'
      element :street, :refund_review_section_field_labelled, 'Street'
      element :locality, :refund_review_section_field_labelled, 'Town/city'
      element :county, :refund_review_section_field_labelled, 'County'
      element :post_code, :refund_review_section_field_labelled, 'Postcode'
      element :telephone_number, :refund_review_section_field_labelled, 'Phone or mobile number'
      element :email_address, :refund_review_section_field_labelled, 'Email Address'
    end
    section :original_claimant_details, :refund_review_section_labelled, 'Original Case Details' do
      element :name, :refund_review_section_field_labelled, 'Claimant name'
      element :building, :refund_review_section_field_labelled, 'Claimant address building number or name'
      element :street, :refund_review_section_field_labelled, 'Claimant address street'
      element :locality, :refund_review_section_field_labelled, 'Claimant address town/city'
      element :county, :refund_review_section_field_labelled, 'Claimant address county'
      element :post_code, :refund_review_section_field_labelled, 'Claimant address post code'
    end

    section :original_case_details, :refund_review_section_labelled, 'Original Case Details' do
      element :et_country_of_claim, :refund_review_section_field_labelled, 'Employment tribunal country of claim'
      element :et_case_number, :refund_review_section_field_labelled, 'Employment tribunal case number'
      element :et_tribunal_office, :refund_review_section_field_labelled, 'Employment tribunal office'
      element :additional_information, :refund_review_section_field_labelled, 'Additional information'
    end

    section :original_respondent_details, :refund_review_section_labelled, 'Original Case Details' do
      element :name, :refund_review_section_field_labelled, 'Respondent name'
      element :building, :refund_review_section_field_labelled, 'Respondent address building number or name'
      element :street, :refund_review_section_field_labelled, 'Respondent address street'
      element :locality, :refund_review_section_field_labelled, 'Respondent address town/city'
      element :county, :refund_review_section_field_labelled, 'Respondent address county'
      element :post_code, :refund_review_section_field_labelled, 'Respondent address post code'
    end

    section :original_representative_details, :refund_review_section_labelled, 'Original Case Details' do
      element :name, :refund_review_section_field_labelled, 'Representative name'
      element :building, :refund_review_section_field_labelled, 'Representative address building number or name'
      element :street, :refund_review_section_field_labelled, 'Representative address street'
      element :locality, :refund_review_section_field_labelled, 'Representative address town/city'
      element :county, :refund_review_section_field_labelled, 'Representative address county'
      element :post_code, :refund_review_section_field_labelled, 'Representative address post code'
    end

    section :original_claim_fees, :refund_review_section_labelled, 'Original Case Fees' do
      section :et_issue, :refund_review_section_fee_type_labelled, 'ET issue' do
        element :fee, :xpath, (XPath.generate {|x| x.descendant(:td)[1]})
        element :payment_method, :xpath, (XPath.generate {|x| x.descendant(:td)[2]})
      end
      section :et_hearing, :refund_review_section_fee_type_labelled, 'ET hearing' do
        element :fee, :xpath, (XPath.generate {|x| x.descendant(:td)[1]})
        element :payment_method, :xpath, (XPath.generate {|x| x.descendant(:td)[2]})
      end
      section :et_reconsideration, :refund_review_section_fee_type_labelled, 'ET reconsideration' do
        element :fee, :xpath, (XPath.generate {|x| x.descendant(:td)[1]})
        element :payment_method, :xpath, (XPath.generate {|x| x.descendant(:td)[2]})
      end
      section :eat_issue, :refund_review_section_fee_type_labelled, 'EAT issue' do
        element :fee, :xpath, (XPath.generate {|x| x.descendant(:td)[1]})
        element :payment_method, :xpath, (XPath.generate {|x| x.descendant(:td)[2]})
      end
      section :eat_hearing, :refund_review_section_fee_type_labelled, 'EAT hearing' do
        element :fee, :xpath, (XPath.generate {|x| x.descendant(:td)[1]})
        element :payment_method, :xpath, (XPath.generate {|x| x.descendant(:td)[2]})
      end
    end
    section :declaration, :xpath, (XPath.generate {|x| x.descendant(:fieldset)[x.descendant(:legend)[x.string.n.is("Declaration")]]}) do
      element :accept, 'I confirm the above'

      def set(value)
        within @root_element do
          check 'refunds_review[accept_declaration]' if value == 'Yes'
          uncheck 'refunds_review[accept_declaration]' if value == 'No'
        end
      end
    end
    element :save_and_continue, 'form.edit_refunds_review input[value="Submit Claim"]'
  end
end
