class CookiesController < MarkdownController
  add_markdown_path   Rails.root.join(*%w<app views cookies markdown>)
  add_markdown_files  %w<general>
end
