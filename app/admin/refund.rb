ActiveAdmin.register Refund do
  filter :submitted_at

  actions :index, :show
  config.clear_action_items!

  batch_action :Export do |ids|
    csv = Refund.to_csv(ids)
    filename = "refund_export_#{Time.now.utc.to_s(:db)}.csv"
    send_data csv, filename: filename
  end
end
