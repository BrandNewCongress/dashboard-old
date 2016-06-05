module AnalyticsIntegration
  class Facebook
    class << self
      def populate_now
        count = fetch_like_count
        AnalyticsIntegration::MetricsStorer.store('facebook_likes', count)
      end
    private
      def fetch_like_count
        fb_token = ENV["FACEBOOK_OAUTH_TOKEN"]
        @graph = Koala::Facebook::API.new(fb_token)
        page = @graph.get_object(ENV["FACEBOOK_PAGE_ID"], fields: ["fan_count"])
        page["fan_count"]
      end
    end
  end
end