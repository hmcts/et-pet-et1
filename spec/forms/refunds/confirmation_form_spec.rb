require 'rails_helper'
module Refunds
  RSpec.describe ConfirmationForm, type: :form do
    let!(:refund_instance) { Refund.new }
    let!(:session_attributes) { { '_refund_id' => 99 } }
    let!(:refund_class) { class_double(Refund).as_stubbed_const }
    let(:refund_session) { double('Session', session_attributes) }
    let(:form) { described_class.new(refund_session) }

    context 'with mock refund' do
      # This is a bit ugly, but the reason for it is we are doing shared examples wrong
      # If we pass in params to the shared example, these are evaluated at spec definition time
      # which is no good if for example, you need to pass in something which is evaluated at
      # spec execution time such as (in this case) an id for a ready build refund record
      let!(:mock_session_class) { class_double(Session).as_stubbed_const }

      before do
        allow(refund_class).to receive(:find_by!).with(id: 99).and_return refund_instance
        allow(mock_session_class).to receive(:new).and_return(refund_session)
      end

      it_behaves_like 'a Form', {}, -> { Session }

    end
  end
end
