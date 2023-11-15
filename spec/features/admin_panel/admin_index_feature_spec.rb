require 'rails_helper'

RSpec.describe 'Viewing the admin interfaces index page', type: :feature do

  let(:out_of_filter_range_claim) do
    create :claim,
           submitted_at: Date.new(2015, 6, 1),
           created_at: Date.new(2015, 6, 1)
  end

  let(:claim) do
    create :claim,
           application_reference: 'SUCH-9999',
           fee_group_reference: '511234567800',
           submitted_at: Date.new(2015, 6, 5),
           # Set created_at to a later date than other models to ensure it's the first row.
           created_at: Date.new(2015, 6, 5)
  end

  before do
    out_of_filter_range_claim
    claim
  end

  it 'viewing a table of claims and their respective details' do
    visit admin_root_path

    claim_row = claims_table.first

    {
      reference: 'SUCH-9999',
      fee_group_reference: '511234567800',
      tribunal_office: 'Birmingham',
      submitted_at: 'June 05, 2015 00:00',
      state: 'Enqueued for submission'
    }.each do |css_class_suffix, expected_column_value|
      column_value = claim_row.find(".col-#{css_class_suffix}").text
      expect(column_value).to eq expected_column_value
    end
  end

  it 'filtering results by submitted_at timestamps' do
    visit admin_root_path

    expect(claims_table.size).to eq 2

    within('.filter_form') do
      fill_in('q_submitted_at_gteq', with: '2015-06-02')
      fill_in('q_submitted_at_lteq', with: '2015-06-05')
    end

    click_button 'Filter'

    expect(claims_table.size).to eq 1

    expected_fee_group_reference = '511234567800'
    expect(page).to have_text expected_fee_group_reference
  end

  def claims_table
    page.all('table tbody tr')
  end
end
