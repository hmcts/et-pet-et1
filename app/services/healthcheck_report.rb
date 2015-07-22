class HealthcheckReport

  def initialize components
    @components = components
  end

  def report
    { status: status_text, components: @components }
  end

  def http_status_code
    application_healthy? ? 200 : 500
  end

  private

  def status_text
    I18n.t "healthcheck.status.#{application_healthy?}"
  end

  def application_healthy?
    @components.all? { |component| component[:available] }
  end

end
