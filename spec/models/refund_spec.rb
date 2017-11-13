require 'rails_helper'

RSpec.describe Refund, type: :model do
  let(:refund1) { build_stubbed :refund, :all_info }
  let(:refund2) { build_stubbed :refund }

  describe 'CSV export' do
    it "return correct CSV headers" do
      export = described_class.to_csv([refund1.id])
      csv = CSV.parse(export)
      expect(csv.first).to eq(
        ['Sumbission reference number', 'First name', 'Surname', '',  '', 'Building number or name/Street',
        'Town/City',  'UK Postcode', 'Date of birth', 'Email address', 'Bank account holder name',
        'Bank sort code', 'Bank account number',
        'Employment tribunal case number', 'Additional information',  'Fee type',  'Payment date (yyyy/mm)',
        'Fee (in pounds)', 'Payment method',  '',  '',  '',  '',  '', 'Building number or name Street', 'Town/City', 'UK Postcode', '','', '','']
      )
    end

    it "return correct CSV headers" do
      allow(Refund).to receive(:where).with(id: [refund1.id, refund2.id]).and_return [refund1, refund2]
      export = described_class.to_csv([refund1.id, refund2.id])
      csv = CSV.parse(export)
      expect(csv[1]).to eq(
        ['1000037', 'Tom', 'Richardson', '', '', '12 Petty France',
        'London/Great London', 'N10 2LE', '1980-02-01', 'tom@hmcts.net', 'Lloyds My account',
        '112233', '12345678', '1234567/2017', 'more information here',
        "ET issue\nET hearing\nET reconsideration\nEAT issue\nEAT hearing",
        "ET issue: 2013/08\nET hearing: 2014/01\nET reconsideration: 2015/04\nEAT issue: 2016/08",
        "ET issue: 10.0 GBP\nET hearing: 20.0 GBP\nET reconsideration: 30.0 GBP\nEAT issue: 40.0 GBP\nEAT hearing: 50.0 GBP",
        "ET issue: card\nET hearing: cheque\nET reconsideration: cash\nEAT issue: unknown\nEAT hearing: card",
        '',  '',  '',  '',  '', '14 Green lane', 'London/Great London', 'N103QS', '','', '','']
      )
    end
  end
end

