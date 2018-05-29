class TermsController < MarkdownController
  add_markdown_path views_term_markdowdon_link
  add_markdown_files [
    'general', 'applicable_law', 'applicable_law_responsible_use',
    'general_data_protection_regulation',
    'privacy_policy', 'disclaimer'
  ]
end
