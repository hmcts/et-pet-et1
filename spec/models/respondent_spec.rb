require 'rails_helper'

RSpec.describe Respondent, :type => :model do
  it { is_expected.to belong_to(:claim) }
  it { is_expected.to have_many(:addresses) }
end
