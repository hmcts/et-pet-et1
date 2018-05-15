ActiveAdmin.register Refund do
  filter :submitted_at

  # no edit, destory, create, etc
  config.clear_action_items!

  collection_action :scotland_claims, method: :get do
    render json: Refund.where(et_country_of_claim: 'scotland')
  end
end
