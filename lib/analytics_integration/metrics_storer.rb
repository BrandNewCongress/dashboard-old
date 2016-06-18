module AnalyticsIntegration
  class MetricsStorer
    class << self
      def store(internal_name, value, datetime = Util::DateUtil.utcized_eastern_time_date)
        metric = Metric.find_by_internal_name(internal_name)
        mp = MetricPoint.where(datetime: datetime, metric: metric).first_or_initialize
        mp.value = value
        mp.save
      end
    end
  end
end