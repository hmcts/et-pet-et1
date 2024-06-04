require 'rails_helper'

RSpec.describe EmploymentForm, type: :form do
  let(:employment_form) { described_class.new resource }

  let(:resource)   { Claim.new employment: }
  let(:employment) { Employment.new }

  it_behaves_like 'it parses dates',
                  :start_date, :end_date, :notice_period_end_date, :new_job_start_date

  describe 'validations' do
    shared_examples 'common date examples' do |field:|
      it 'rejects a 2 digit year' do
        employment_form.attributes = { "#{field}(3i)" => '1', "#{field}(2i)" => '1', "#{field}(1i)" => '16' }
        employment_form.valid?
        expect(employment_form.errors.details[field]).to include(a_hash_including(error: :invalid))

      end

      it 'rejects a missing year' do
        employment_form.attributes = { "#{field}(3i)" => '1', "#{field}(2i)" => '1', "#{field}(1i)" => '' }
        employment_form.valid?
        expect(employment_form.errors.details[field]).to include(a_hash_including(error: :invalid))
      end

      it 'rejects a missing month' do
        employment_form.attributes = { "#{field}(3i)" => '1', "#{field}(2i)" => '', "#{field}(1i)" => '2010' }
        employment_form.valid?
        expect(employment_form.errors.details[field]).to include(a_hash_including(error: :invalid))
      end

      it 'rejects a missing day' do
        employment_form.attributes = { "#{field}(3i)" => '', "#{field}(2i)" => '1', "#{field}(1i)" => '2010' }
        employment_form.valid?
        expect(employment_form.errors.details[field]).to include(a_hash_including(error: :invalid))
      end

    end

    [:gross_pay, :new_job_gross_pay].each do |attribute|
      it { expect(employment_form).to validate_numericality_of(attribute).allow_nil }
    end

    it 'should validate net_pay if gross_pay is present' do
      expect(employment_form).to validate_numericality_of(:net_pay)
    end

    { new_job_gross_pay_frequency: :new_job_gross_pay, notice_pay_period_type: :notice_pay_period_count }.
      each do |type, pay|
      describe type.to_s do
        context "when #{pay} is true" do
          before { employment_form.send "#{pay}=", "100" }

          it { expect(employment_form).to validate_presence_of type }
        end

        context "when #{pay} is false" do
          it { expect(employment_form).not_to validate_presence_of type }
        end
      end
    end

    describe 'end_date' do
      include_examples 'common date examples', field: :end_date
    end

    describe 'new_job_start_date' do
      include_examples 'common date examples', field: :new_job_start_date
    end

    describe 'notice_period_end_date' do
      include_examples 'common date examples', field: :notice_period_end_date
    end

    describe 'start_date' do
      include_examples 'common date examples', field: :start_date
    end

    context 'when end date before start date' do

      it 'rejects when end_date is before start_date' do
        employment_form.start_date = '1/1/2015'
        employment_form.end_date = '1/1/2014'

        employment_form.valid?
        expect(employment_form.errors.where(:end_date, :end_date_before_start_date)).not_to be_empty
      end
    end

    context 'when notice_period_end_date before start date' do

      it 'rejects when notice_period_end_date is before start_date' do
        employment_form.start_date = '1/1/2015'
        employment_form.notice_period_end_date = '1/1/2014'

        employment_form.valid?
        expect(employment_form.errors.where(:notice_period_end_date, :notice_period_end_date_before_start_date)).not_to be_empty
      end
    end
  end

  describe "average hours worked per week" do
    [
      { value: 169, error_message: "less_than_or_equal_to" },
      { value: 0, error_message: "greater_than" },
      { value: "abcd", error_message: "not_a_number" }
    ].each do |example|
      it "validates that hours worked #{example[:error_message] == 'not_a_number' ? 'must be numerical' : "cannot be #{example[:error_message]}"} #{example[:value]}" do
        employment_form.average_hours_worked_per_week = example[:value]
        employment_form.valid?
        expect(employment_form.errors[:average_hours_worked_per_week]).to include(I18n.t("activemodel.errors.models.employment.attributes.average_hours_worked_per_week.#{example[:error_message]}"))
      end
    end
  end

  describe "net pay" do
    it 'must be less than or equal to gross pay' do
      employment_form.net_pay = 10_000
      employment_form.gross_pay = 6000
      employment_form.valid?
      expect(employment_form.errors[:net_pay]).to include("Net pay must be lower than gross pay")
    end
  end

  [:gross_pay, :net_pay, :new_job_gross_pay].each do |attr|
    describe "#{attr}=" do
      before { employment_form.send "#{attr}=", '10,000' }

      it 'strips commas entered by the user' do
        expect(employment_form.send(attr)).to eq 10_000
      end
    end
  end

  describe '#was_employed' do
    context 'when the employment model has not been persisted' do
      before { allow(employment).to receive_messages persisted?: false }

      it 'is nil' do
        expect(employment_form.was_employed).to be_nil
      end
    end

    context 'when the employment model return true' do
      before { employment_form.was_employed = true }

      it 'is true' do
        expect(employment_form.was_employed).to be true
      end
    end
  end

  describe 'callbacks' do
    context 'when not previously employed' do
      before { employment_form.was_employed = 'false' }

      it 'destroys the representative relation' do
        expect(employment).to receive :destroy
        employment_form.save
      end
    end

    context 'when previously employed' do
      before do
        employment_form.assign_attributes worked_notice_period_or_paid_in_lieu: true,
                                          notice_period_end_date: 1.week.ago.to_date, end_date: Time.zone.today,
                                          notice_pay_period_count: '1', notice_pay_period_type: 'weeks',
                                          found_new_job: 'true', new_job_start_date: 1.week.from_now.to_date,
                                          new_job_gross_pay: '100', new_job_gross_pay_frequency: 'monthly',
                                          was_employed: 'true'
      end

      context 'when still employed' do
        before do
          employment_form.current_situation = 'still_employed'
          employment_form.valid?
        end

        context 'when previously entered other information clears other fields' do
          it { expect(employment_form.notice_period_end_date).to be nil }
          it { expect(employment_form.end_date).to be nil }
          it { expect(employment_form.new_job_start_date).to be nil }
        end
      end

      context 'with empty current_situation' do
        before do
          employment_form.current_situation = nil
          employment_form.valid?
        end

        it { expect(employment_form).not_to be_valid }
        it { expect(employment_form.errors.details[:current_situation]).to eql([{ error: :blank }]) }
      end

      context 'when in notice period clears other fields but keeps notice period end dat' do
        before do
          employment_form.current_situation = 'notice_period'
          employment_form.valid?
        end

        it { expect(employment_form.notice_period_end_date).not_to be nil }
        it { expect(employment_form.end_date).to be nil }
        it { expect(employment_form.new_job_start_date).to be nil }
      end

      context 'when employment terminated' do
        before { employment_form.current_situation = 'employment_terminated' }

        context 'when previously entered new job details' do
          context 'when selecting no new job clears new job details' do
            before do
              employment_form.found_new_job = false
              employment_form.valid?
            end

            it { expect(employment_form.new_job_start_date).to be nil }
            it { expect(employment_form.new_job_gross_pay).to be nil }
            it { expect(employment_form.new_job_gross_pay_frequency).to be nil }
          end

          context 'when selecting new job details are not removed' do
            before do
              employment_form.found_new_job = 'true'
              employment_form.valid?
            end

            it { expect(employment_form.new_job_start_date).not_to be nil }
            it { expect(employment_form.new_job_gross_pay).not_to be nil }
            it { expect(employment_form.new_job_gross_pay_frequency).not_to be nil }
          end
        end

        context 'when previously entered notice period details' do
          context 'when selecting no notice period clears notice period details' do
            before do
              employment_form.worked_notice_period_or_paid_in_lieu = 'false'
              employment_form.valid?
            end

            it { expect(employment_form.notice_pay_period_count).to be nil }
            it { expect(employment_form.notice_pay_period_type).to be nil }
          end
        end
      end
    end
  end
end
