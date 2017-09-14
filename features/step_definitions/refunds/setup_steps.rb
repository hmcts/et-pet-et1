And(/^I want a refund for my previous ET claim with case number "1234567\/2016"$/) do
  respondent = OpenStruct.new name: 'Respondent Name',
                              post_code: 'SW1H 9QR'
  representative = OpenStruct.new name: 'Representative Name',
                                  post_code: 'SW2H 9ST'
  fees = OpenStruct.new et_issue_fee: '1000.00',
                        et_issue_payment_method: 'Card',
                        et_hearing_fee: '1001.00',
                        et_hearing_payment_method: 'Cash',
                        eat_issue_fee: '1002.00',
                        eat_issue_payment_method: 'Cheque',
                        eat_hearing_fee: '1003.00',
                        eat_hearing_payment_method: 'Card',
                        app_reconsideration_fee: '1004.00',
                        app_reconsideration_payment_method: 'Card'

  self.test_et_claim_to_refund = OpenStruct.new et_case_number: '1234567/2016',
                                                et_tribunal_office: 'NG0001',
                                                additional_information: 'REF1, REF2, REF3',
                                                respondent: respondent.freeze,
                                                representative: representative.freeze,
                                                fees: fees.freeze
  test_et_claim_to_refund.freeze
end
