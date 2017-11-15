require 'rails_helper'

RSpec.describe RefundCSVExport, type: :service do

  let(:refund1) { create :refund, :all_info }
  let(:refund2) { create :refund, :society_payment }

  describe 'CSV export' do
    it "return correct CSV headers" do
      export = described_class.new([refund1.id])
      csv = CSV.parse(export.run)
      expect(csv.first).to eq(
        ['Sumbission reference number', 'First name', 'Surname', '', '', 'Building number/Street name',
         'Town/City', 'UK Postcode', 'Date of birth', 'Email address', 'Bank account holder name',
         'Bank sort code', 'Bank account number',
         'Employment tribunal case number', 'Additional information', 'Fee type', 'Payment date (yyyy/mm)',
         'Fee (in pounds)', 'Payment method', '', '', '', '', '', 'Building number/Street name', 'Town/City', 'UK Postcode', '', '', '', '']
      )
    end

    describe 'CSV DATA' do
      let(:export_data) do
        export = described_class.new([refund1.id, refund2.id])
        CSV.parse(export.run)
      end

      let(:export_first_line) { export_data[1] }
      let(:export_second_line) { export_data[2] }

      context 'first line' do
        it "First name" do
          expect(export_first_line[1]).to eql('Tom')
        end

        it "Surname" do
          expect(export_first_line[2]).to eql('Richardson')
        end

        it "Building number or Street" do
          expect(export_first_line[5]).to eql('12 Petty France')
        end

        it "Town/City" do
          expect(export_first_line[6]).to eql('London/Great London')
        end

        it "UK Postcode" do
          expect(export_first_line[7]).to eql('N10 2LE')
        end

        it "Date of birth" do
          expect(export_first_line[8]).to eql('1980-02-01')
        end

        it "Email address" do
          expect(export_first_line[9]).to eql('tom@hmcts.net')
        end

        it "Bank account holder name" do
          expect(export_first_line[10]).to eql('Lloyds My account')
        end

        it "Bank sort code" do
          expect(export_first_line[11]).to eql('112233')
        end

        it "Bank account number" do
          expect(export_first_line[12]).to eql('12345678')
        end

        it "Employment tribunal case number" do
          expect(export_first_line[13]).to eql('1234567/2017')
        end

        it "Additional information" do
          expect(export_first_line[14]).to eql('more information here')
        end

        it "Fee type" do
          expect(export_first_line[15]).to eql("ET issue\nET hearing\nET reconsideration\nEAT issue\nEAT hearing")
        end

        it "Fee Payment date (yyyy/mm)" do
          expect(export_first_line[16]).to eql("ET issue: 2013/08\nET hearing: 2014/01\nET reconsideration: 2015/04\nEAT issue: 2016/08")
        end

        it "Fee (in pounds)" do
          expect(export_first_line[17]).to eql("ET issue: 10.0 GBP\nET hearing: 20.0 GBP\nET reconsideration: 30.0 GBP\nEAT issue: 40.0 GBP\nEAT hearing: 50.0 GBP")
        end

        it "Fee Payment method" do
          expect(export_first_line[18]).to eql("ET issue: card\nET hearing: cheque\nET reconsideration: cash\nEAT issue: unknown\nEAT hearing: card")
        end

        it "Original Building number/Street name" do
          expect(export_first_line[24]).to eql('14 Green lane')
        end

        it "Original Town/City" do
          expect(export_first_line[25]).to eql('London/Great London')
        end

        it "Original UK Postcode" do
          expect(export_first_line[26]).to eql('N103QS')
        end

        it "is blank" do
          [3, 4, 19, 20, 21, 22, 23, 27, 28, 29, 30].each do |column|
            expect(export_first_line[column]).to be_blank
          end
        end
      end

      context 'second line' do
        it "First name" do
          expect(export_second_line[1]).to eql('First')
        end

        it "Surname" do
          expect(export_second_line[2]).to eql('Last')
        end

        it "Building number or Street" do
          expect(export_second_line[5]).to eql('30 Applicant Street')
        end

        it "Town/City" do
          expect(export_second_line[6]).to eql('Applicant Locality/Applicant County')
        end

        it "UK Postcode" do
          expect(export_second_line[7]).to eql('DE25 1ZY')
        end

        it "Date of birth" do
          expect(export_second_line[8]).to eql('')
        end

        it "Email address" do
          expect(export_second_line[9]).to eql(refund2.email_address)
        end

        it "Bank account holder name" do
          expect(export_second_line[10]).to eql('Yorkshire Building Society Tom Dunhill')
        end

        it "Bank sort code" do
          expect(export_second_line[11]).to eql('332211')
        end

        it "Bank account number" do
          expect(export_second_line[12]).to eql('98765432')
        end

        it "Employment tribunal case number" do
          expect(export_second_line[13]).to eql('1234567/2016')
        end

        it "Additional information" do
          expect(export_second_line[14]).to eql('Some extra information')
        end

        it "Fee type" do
          expect(export_second_line[15]).to eql("ET issue")
        end

        it "Fee Payment date (yyyy/mm)" do
          expect(export_second_line[16]).to eql("ET issue: 2013/08")
        end

        it "Fee (in pounds)" do
          expect(export_second_line[17]).to eql("ET issue: 10.0 GBP")
        end

        it "Fee Payment method" do
          expect(export_second_line[18]).to eql("ET issue: card")
        end

        it "Original Building number/Street name" do
          expect(export_second_line[24]).to eql('30 Claimant Street')
        end

        it "Original Town/City" do
          expect(export_second_line[25]).to eql('Claimant Locality/Claimant County')
        end

        it "Original UK Postcode" do
          expect(export_second_line[26]).to eql('DE24 1ZY')
        end

        it "is blank" do
          [3, 4, 19, 20, 21, 22, 23, 27, 28, 29, 30].each do |column|
            expect(export_second_line[column]).to be_blank
          end
        end
      end

    end
  end
end
