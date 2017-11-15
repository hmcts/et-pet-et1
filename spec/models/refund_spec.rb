require 'rails_helper'

RSpec.describe Refund, type: :model do
  describe 'total_fees' do
    let(:refund1) { build :refund, et_issue_fee: 10 }
    let(:refund2) { build :refund, et_issue_fee: 10, et_hearing_fee: 11 }
    let(:refund3) { build :refund, et_issue_fee: 10, et_hearing_fee: 11, et_reconsideration_fee: 12 }
    let(:refund4) { build :refund, et_issue_fee: 10, et_hearing_fee: 11, et_reconsideration_fee: 12, eat_issue_fee: 13 }
    let(:refund5) { build :refund, et_issue_fee: 10, et_hearing_fee: 11, et_reconsideration_fee: 12, eat_issue_fee: 13, eat_hearing_fee: 14 }

    it "et_issue_fee only" do
      expect(refund1.total_fees).to eq(10)
    end

    it "et_issue_fee and et_hearing_fee" do
      expect(refund2.total_fees).to eq(21)
    end

    it "et_issue_fee and et_hearing_fee and et_reconsideration_fee" do
      expect(refund3.total_fees).to eq(33)
    end

    it "et_issue_fee and et_hearing_fee and et_reconsideration_fee and eat_issue_fee" do
      expect(refund4.total_fees).to eq(46)
    end

    it "et_issue_fee and et_hearing_fee and et_reconsideration_fee and eat_issue_fee and eat_hearing_fee" do
      expect(refund5.total_fees).to eq(60)
    end
  end
end
