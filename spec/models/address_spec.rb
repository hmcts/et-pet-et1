require 'rails_helper'

describe Address do
  it { is_expected.to belong_to :addressable }
end
