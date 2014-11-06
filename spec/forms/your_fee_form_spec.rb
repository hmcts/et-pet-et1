require 'rails_helper'

RSpec.describe YourFeeForm, :type => :form do
  it_behaves_like("a Form", applying_for_remission: true)
end
