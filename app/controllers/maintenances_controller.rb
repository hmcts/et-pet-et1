class MaintenancesController < MarkdownController
  add_markdown_path   Rails.root.join(*%w<app views maintenances markdown>)
  add_markdown_files  %w<service_suspended>
end
