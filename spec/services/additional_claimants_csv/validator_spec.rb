require "rails_helper"
require 'tempfile'

RSpec.describe AdditionalClaimantsCsv::Validator, type: :service do
  before {
    I18n.locale = :en
  }
  describe "#validate" do

    let(:valid_header) {
      ["Title", "First name", "Last name", "Date of birth", "Building number or name",
       "Street", "Town/city", "County", "Postcode"].join(",")
    }

    let(:valid_csv_data) {
      ["Mr,Henry,Bigglesworth,13/08/1937,12,High Street,London,London,SW1 6FF",
       "Mrs,Marie,Dobbin,13/08/1937,12,High Street,London,London,SW1 6FF",
       "Mr,Shergar,Bigglesworth,13/08/1937,12,High Street,London,London,SW1 6FF",
       "Miss,Henrietta,Bigglesworth,13/08/1937,12,High Street,London,London,SW1 6FF"]
    }

    context "a correct csv file" do
      describe "validates if all fields are present" do
        let(:result) { setup_csv_validator(valid_csv_data) }

        it { expect(result.success).to eq true }
        it { expect(result.errors).to be_empty }
        it { expect(result.line_count).to eq 4 }
      end
    end

    context "csv file with validation errors" do

      describe "fails with an invalid title" do
        let(:invalid_title_row) { "Dr,Henry,Biggles,13/08/1937,12,High Street,London,London,SW1 6FF" }
        let(:result) { setup_csv_validator(invalid_title_row) }

        it { expect(result.success).to eq false }
        it { expect(result.errors).to eq ["Title - Enter the title of the additional claimant"] }
      end

      describe "fails with a non DD/MM/YYYY D.O.B" do
        let(:invalid_dob_row) { "Mr,Henry,Biggles,invalid_date,12,High Street,London,London,SW1 6FF" }
        let(:result) { setup_csv_validator(invalid_dob_row) }

        it { expect(result.success).to eq false }
        it { expect(result.errors).to eq ["Date of birth - Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)"] }
      end

      describe "fails if no DOB is present" do
        let(:valid_no_dob_row) { "Mr,Henry,Biggles,,12,High Street,London,London,SW1 6FF" }
        let(:result) { setup_csv_validator(valid_no_dob_row) }

        it { expect(result.success).to eq false }
        it { expect(result.errors).to eq ["Date of birth - Claimant must be 16 years of age or over"] }
      end

      describe "fails with a non valid postcode" do
        let(:invalid_postcode_row) { "Mr,Henry,Biggles,13/08/1937,12,High Street,London,London,SUPER!" }
        let(:result) { setup_csv_validator(invalid_postcode_row) }

        it { expect(result.success).to eq false }
        it { expect(result.errors).to eq ["Postcode - Enter a valid UK postcode. If you live abroad, enter SW55 9QT"] }
      end

      describe "fails with an invalid character count" do
        let(:invalid_char_count_row) { "Mr,Fred,Star,10/10/1984,3,#{Array.new(76) { 'a' }.join},London,London,se1 7nx" }
        let(:result) { setup_csv_validator(invalid_char_count_row) }

        it { expect(result.success).to eq false }
        it { expect(result.errors).to eq ["Street - The information you have provided for this field must not exceed 50 characters"] }
      end

      it "yields the line number of the invalid record" do
        broken_row = ","
        result = setup_csv_validator(broken_row)

        expect(result.error_line).to eq 2
      end

      describe "fails validation when no data is present in a row" do
        let(:empty_row) { "\n" }
        let(:result) { setup_csv_validator(empty_row) }

        it { expect(result.success).to eq false }
        it { expect(result.errors).not_to be_empty }
      end

      describe "fails if incorrect headers are used" do
        let(:invalid_header) { "such,invalid,header,so,broken" }
        let(:result) { setup_csv_validator(valid_csv_data, invalid_header) }

        it { expect(result.success).to eq false }
        it { expect(result.errors).to eq ["The CSV doesn’t appear to be formatted correctly."] }
      end
    end
  end

  def setup_csv_validator(rows, header = valid_header)
    file = Tempfile.new('example.csv')
    file.write([header, *rows].join("\n"))
    file.close
    claim = create :claim, additional_claimants_csv: file
    described_class.new(claim).validate
  end
end
