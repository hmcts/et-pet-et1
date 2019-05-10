module MaintenanceNoticeHelper
  def maintenance_notice
    (start_time, end_time) = ENV['SHOW_DOWNTIME_BANNER'].split(',').map do |d|
      Time.zone.parse(d.strip).strftime("%l%P")
    end

    day = I18n.localize(Time.zone.parse(ENV['SHOW_DOWNTIME_BANNER'].split(',').last.strip), format: "%e %B %Y")

    t('maintenance.notice_string', start_time: start_time, end_time: end_time, day: day)
  end

end
