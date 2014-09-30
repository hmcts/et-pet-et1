require 'rails_helper'

describe Employment do
  it { is_expected.to belong_to :claim }
end
