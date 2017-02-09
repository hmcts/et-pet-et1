require "rails_helper"
require 'tempfile'

RSpec.describe AdditionalClaimantsCsv::Validator, type: :service do

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
      it "validates if all fields are present" do
        result = setup_csv_validator(valid_csv_data)

        expect(result.success).to eq true
        expect(result.errors).to be_empty
        expect(result.line_count).to eq 4
      end

      it "validates if no DOB is present" do
        valid_no_dob_row = "Mr,Henry,Biggles,,12,High Street,London,London,SW1 6FF"
        result = setup_csv_validator(valid_no_dob_row)

        expect(result.success).to eq true
      end
    end

    context "csv file with validation errors" do

      it "fails with an invalid title" do
        invalid_title_row = "Dr,Henry,Biggles,13/08/1937,12,High Street,London,London,SW1 6FF"
        result = setup_csv_validator(invalid_title_row)

        expect(result.success).to eq false
        expect(result.errors).to eq ["Title - Enter the title of the additional claimant"]
      end

      it "fails with a non DD/MM/YYYY D.O.B" do
        invalid_dob_row = "Mr,Henry,Biggles,invalid_date,12,High Street,London,London,SW1 6FF"
        result = setup_csv_validator(invalid_dob_row)

        expect(result.success).to eq false
        expect(result.errors).to eq ["Date of birth - Enter the claimant’s date of birth in the correct format (DD/MM/YYYY)"]
      end

      it "fails with a non valid postcode" do
        invalid_postcode_row = "Mr,Henry,Biggles,13/08/1937,12,High Street,London,London,SUPER!"
        result = setup_csv_validator(invalid_postcode_row)

        expect(result.success).to eq false
        expect(result.errors).to eq ["Postcode - Enter a valid UK postcode. If you live abroad, enter SW55 9QT"]
      end

      it "fails with an invalid character count" do
        invalid_char_count_row = "Mr,Fred,Star,10/10/1984,3,#{ Array.new(76) { 'a' }.join },London,London,se1 7nx"
        result = setup_csv_validator(invalid_char_count_row)

        expect(result.success).to eq false
        expect(result.errors).
          to eq ["Street - The information you have provided for this field must not exceed 75 characters"]
      end

      it "yields the line number of the invalid record" do
        broken_row = ","
        result = setup_csv_validator(broken_row)

        expect(result.error_line).to eq 2
      end

      it "fails validation when no data is present in a row" do
        empty_row = "\n"
        result = setup_csv_validator(empty_row)

        expect(result.success).to eq false
        expect(result.errors).not_to be_empty
      end

      it "fails if incorrect headers are used" do
        invalid_header = "such,invalid,header,so,broken"
        result = setup_csv_validator(valid_csv_data, invalid_header)

        expect(result.success).to eq false
        expect(result.errors).to eq ["The CSV doesn’t appear to be formatted correctly."]
      end
    end
  end

  def setup_csv_validator(rows, header=valid_header)
    file = Tempfile.new('example.csv')
    file.write([header, *rows].join("\n"))
    file.close
    claim = create :claim, additional_claimants_csv: file
    return described_class.new(claim).validate
  end
end
