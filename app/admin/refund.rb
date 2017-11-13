ActiveAdmin.register Refund do
  filter :submitted_at

  actions :index, :show
  config.clear_action_items!

  batch_action :Export do |ids|
    csv = Refund.to_csv(ids)
    send_data csv
    # redirect_to collection_path, alert: "The File was exported"
  end
end
