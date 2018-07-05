ActiveAdmin.register Diversity do
  filter :created_at

  actions :all, :except => [:destroy, :edit]

  config.clear_action_items!
end
