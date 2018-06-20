ActiveAdmin.register Diversity do
  filter :created_at

  # no edit, destory, create, etc
  config.clear_action_items!
end
