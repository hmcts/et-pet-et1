ActiveAdmin.register Claim do
  filter :submitted_at
  filter :state

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

    column(:payment_status) { |claim| Admin::PaymentStatus.for claim }

    column(:tribunal_office) { |claim| claim.office.try :name }

    column :submitted_at

    column(:state) { |claim| claim.state.humanize }
  end

  member_action :generate_pdf, method: :post do
    PdfGenerationJob.perform_later resource
    redirect_to :back, notice: 'Generating a new PDF'
  end

  member_action :submit_claim, method: :post do
    if resource.enqueued_for_submission?
      ClaimSubmissionJob.perform_later resource
      resource.create_event Event::MANUALLY_SUBMITTED, actor: 'admin'
    end

    redirect_to :back, notice: 'Claim submitted to Jadu'
  end

  member_action :mark_submitted, method: :post do
    resource.finalize!
    resource.create_event Event::MANUAL_STATUS_CHANGE, actor: "admin", message: "status changed to submitted"

    redirect_to :back, notice: 'Claim marked as submitted'
  end

  member_action :txt_file, method: :get do
    text = case params[:type]
           when 'claim_details' then
             resource.claim_details
           when 'miscellaneous_information' then
             resource.miscellaneous_information
           when 'other_claim_details' then
             resource.other_claim_details
           when 'other_outcome' then
             resource.other_outcome
           end

    send_data text, filename: "#{resource.reference}-#{params[:type]}.txt"
  end

  sidebar :actions, only: :show do
    div { button_to 'Generate PDF', action: :generate_pdf }

    if resource.pdf_present?
      br
      div do
        link_to 'Download PDF', resource.pdf_url, class: :button
      end
    end

    if resource.claim_details_rtf?
      br
      div do
        link_to 'Download RTF', resource.claim_details_rtf_url, class: :button
      end
    end

    if resource.additional_claimants_csv?
      br
      div do
        link_to 'Download CSV', resource.additional_claimants_csv_url, class: :button
      end
    end

    %w<claim_details miscellaneous_information other_claim_details other_outcome>.each do |text|
      next if resource.send(text).blank?
      br
      div do
        link_to "#{text.humanize}", { action: :txt_file, type: text }, { class: :button }
      end
    end

    if resource.enqueued_for_submission?
      { mark_submitted: "Mark as submitted",
       submit_claim: "Submit claim" }.each do |action, text|
        br
        div do
          div { button_to text, action: action }
        end
      end
    end
  end

  # Show
  show title: :reference do
    panel 'Metadata' do
      attributes_table_for claim do
        row(:id)
        row('Submitted to JADU') { |c| c.submitted? ? c.submitted_at : 'No' }
        row('Payment required') { |c| c.fee_to_pay? ? 'Yes' : 'No' }
        row('Payment received') { |c| c.payment_present? ? 'Yes' : 'No' }
        row :fee_group_reference

        row('FGR postcode') do |c|
          if c.fee_group_reference
            res = c.primary_respondent
            [res.work_address, res.address].
              find { |a| a.post_code.present? }.
              post_code
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
