module MaintenanceNoticeHelper
  def maintenance_notice
    (start_time, end_time) = ENV['SHOW_DOWNTIME_BANNER'].split(',').
      map { |d|  Time.zone.parse(d.strip).strftime("%l%P") }

    day = Time.zone.parse(ENV['SHOW_DOWNTIME_BANNER'].split(',').last.strip).strftime("%e %B %Y")

    "We're planning maintenance of this service. It will be unavailable from #{start_time} to #{end_time} on #{day}."
  end

end
