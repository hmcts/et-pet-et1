shared_context 'fake gov notify' do
  before do
    WebMock.stub_request(:any, /https:\/\/api\.notifications\.service\.gov\.uk/).to_rack(GovFakeNotify::RootApp)
  end
end