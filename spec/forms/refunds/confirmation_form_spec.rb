require 'rails_helper'
module Refunds
  RSpec.describe ConfirmationForm, type: :form do
    let(:refund) { instance_spy(Refund) }
    let(:form) { described_class.new(refund) }

    it_behaves_like 'a Form', {}, Refund
  end
end
