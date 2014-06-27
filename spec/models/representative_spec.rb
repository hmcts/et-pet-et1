require 'rails_helper'

RSpec.describe Representative, :type => :model do
  it { is_expected.to have_one :address }
  it { is_expected.to belong_to :claim }
end
