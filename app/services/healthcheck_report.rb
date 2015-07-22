class HealthcheckReport
  def initialize(component_statuses)
    @component_statuses = component_statuses
  end

  def report
    { status: status_text, components: @component_statuses }
  end

  def http_status_code
    application_healthy? ? 200 : 500
  end

  private

  def status_text
    I18n.t "healthcheck.status.#{application_healthy?}"
  end

  def application_healthy?
    @component_statuses.all? { |component_status| component_status[:available] }
  end
end
