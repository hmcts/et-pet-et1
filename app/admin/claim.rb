ActiveAdmin.register Claim do
  filter :submitted_at

  # no edit, destory, create, etc
  config.clear_action_items!
  actions :index, :show

  controller { defaults finder: :find_by_reference }

  # Index page
  index download_links: false do
    column :reference do |claim|
      link_to claim.reference, admin_claim_path(claim.reference)
    end

    column :fee_group_reference

    column(:payment_status) do |claim|
      case
      when !claim.immutable?
        'Not submitted'
      when claim.remission_claimant_count > 0
        'Remission indicated'
      when claim.payment_present?
        'Paid'
      else
        'Missing payment'
      end
    end

    column(:tribunal_office) { |claim| claim.office.try :name }

    column :submitted_at

    column(:state) { |claim| claim.state.humanize }

  end

  member_action :generate_pdf, method: :post do
    PdfGenerationJob.perform_later resource
    redirect_to :back, notice: 'Generating a new PDF'
  end

  sidebar :actions, only: :show do
    div { button_to 'Generate PDF', action: :generate_pdf }
    br
    div do
      if resource.pdf_present?
        link_to 'Download PDF', resource.pdf_url, class: :button
      end
    end

    br
    div do
      if resource.additional_information_rtf?
        link_to 'Download RTF', resource.additional_information_rtf_url, class: :button
      end
    end

    br
    div do
      if resource.additional_claimants_csv?
        link_to 'Download CSV', resource.additional_claimants_csv_url, class: :button
      end
    end
  end

  # Show
  show title: :reference do
    panel 'Metadata' do
      attributes_table_for claim do
        row(:id)
        row('Submitted to JADU') { |c| c.submitted? ? c.submitted_at : 'No' }
        row('Payment required')  { |c| c.fee_to_pay? ? 'Yes' : 'No' }
        row('Payment received')  { |c| c.payment_present? ? 'Yes' : 'No' }
        row :fee_group_reference

        row('FGR postcode') do |c|
          if c.fee_group_reference
            addresses = c.primary_respondent.addresses

            (addresses.where(primary: false).first || addresses.first).post_code
          end
        end

        row('Confirmation emails') do |c|
          c.confirmation_email_recipients.to_sentence
        end
      end
    end

    panel 'Events' do
      table_for claim.events do
        column :event
        column :actor
        column :created_at
        column :message
      end
    end
  end
end
