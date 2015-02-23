class BarclaycardPaymentTemplateController < ActionController::Base
  # Assets must be provided as absolute so that they are available
  # when Barclays displays the page
  self.asset_host = ENV.fetch 'ASSET_HOST'

  layout 'application'
end
