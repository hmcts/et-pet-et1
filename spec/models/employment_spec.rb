require 'rails_helper'

RSpec.describe Employment, type: :model do
  it { is_expected.to belong_to :claim }
end
