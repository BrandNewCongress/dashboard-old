module Util
  class DateUtil
    class << self
      def utcized_eastern_time_date
        eastern_time_date_str = ActiveSupport::TimeZone["America/New_York"].now.strftime("%Y-%m-%d")
        DateTime.parse(eastern_time_date_str)
      end

      def eastern_time_start_of_day(date)
        ActiveSupport::TimeZone["America/New_York"].parse(date).beginning_of_day
      end

      def eastern_time_end_of_date(date)
        ActiveSupport::TimeZone["America/New_York"].parse(date).end_of_day
      end

      def eastern_time_days_ago(num_days)
        eastern_day_string(ActiveSupport::TimeZone["America/New_York"].now - num_days.days)
      end

      def utc_parse_day(date)
        ActiveSupport::TimeZone["UTC"].parse(date)
      end

      def eastern_day_string(date)
        date.in_time_zone(ActiveSupport::TimeZone["America/New_York"]).strftime("%Y-%m-%d")
      end
    end
  end
end