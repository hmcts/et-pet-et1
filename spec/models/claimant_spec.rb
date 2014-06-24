require 'rails_helper'

RSpec.describe Claimant, :type => :model do
  it { is_expected.to have_one :address }
end
