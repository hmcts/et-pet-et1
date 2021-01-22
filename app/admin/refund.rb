ActiveAdmin.register Refund do
  filter :submitted_at
  filter :claimant_name
  filter :application_reference

  # no edit, destory, create, etc
  config.clear_action_items!
end
