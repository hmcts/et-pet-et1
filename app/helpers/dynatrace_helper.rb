module DynatraceHelper
  def dynatrace_script_tag
    return unless Rails.application.config.dynatrace_ui_tracking_id

    render partial: 'shared/dynatrace_script_tag',
           locals: { dynatrace_ui_tracking_id: Rails.application.config.dynatrace_ui_tracking_id }
  end
end
