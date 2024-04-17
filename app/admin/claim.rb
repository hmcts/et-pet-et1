# rubocop:disable Metrics/BlockLength
ActiveAdmin.register Claim do
  filter :submitted_at
  filter :state, as: :select,
                 collection: [
                   :created,
                   :enqueued_for_submission, :submitted
                 ]
  filter :fee_group_reference
  filter :application_reference

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

    column(:tribunal_office) { |claim| claim.office.try :name }

    column :submitted_at

    column(:state) { |claim| claim.state.humanize }
  end

  member_action :submit_claim, method: :post do
    response = EtApi.create_claim(resource)
    unless response.valid?
      resource.update state: 'submission_failed'
      raise "An error occured in the API - #{response.errors.full_messages}"
    end
    resource.update state: 'submitted', pdf_url: response.response_data.dig('meta', 'BuildClaim', 'pdf_url')
    resource.create_event Event::MANUALLY_SUBMITTED, actor: 'admin'
    redirect_back notice: 'Claim submitted to API', fallback_location: admin_claim_url(resource)
  end

  member_action :mark_submitted, method: :post do
    resource.finalize!
    resource.create_event(
      Event::MANUAL_STATUS_CHANGE,
      actor: "admin",
      message: "status changed to submitted"
    )

    redirect_back notice: 'Claim marked as submitted', fallback_location: admin_claim_url(resource)
  end

  member_action :txt_file, method: :get do
    text = case params[:type]
           when 'claim_details'
             resource.claim_details
           when 'miscellaneous_information'
             resource.miscellaneous_information
           when 'other_claim_details'
             resource.other_claim_details
           when 'other_outcome'
             resource.other_outcome
           end

    send_data text, filename: "#{resource.reference}-#{params[:type]}.txt"
  end

  sidebar :actions, only: :show do
    ['claim_details', 'miscellaneous_information',
     'other_claim_details', 'other_outcome'].each do |text|
      next if resource.send(text).blank?

      br
      div do
        link_to text.humanize.to_s, { action: :txt_file, type: text }, class: :button
      end
    end

    if resource.enqueued_for_submission? || resource.submitted?
      { mark_submitted: "Mark as submitted",
        submit_claim: "Submit claim" }.each do |action, text|
        br
        div do
          div { button_to text, action:, method: :post }
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
        row :fee_group_reference
        row :state

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
# rubocop:enable Metrics/BlockLength
