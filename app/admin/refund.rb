ActiveAdmin.register Refund do
  filter :submitted_at

  # no edit, destory, create, etc
  config.clear_action_items!
end
