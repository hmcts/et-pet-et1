class TermsController < MarkdownController
  add_markdown_path   Rails.root.join(*%w<app views terms markdown>)
  add_markdown_files  %w<general applicable_law privacy_policy data_protection disclaimer>
end
