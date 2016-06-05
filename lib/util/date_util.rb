module Util
  class DateUtil
    class << self
      def utcized_eastern_time_date
        eastern_time_date_str = ActiveSupport::TimeZone["America/New_York"].now.strftime("%Y-%m-%d")
        DateTime.parse(eastern_time_date_str)
      end
    end
  end
end