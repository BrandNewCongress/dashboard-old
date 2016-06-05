module AnalyticsIntegration
  class Facebook
    class << self
      def populate_now
        count = fetch_like_count
        AnalyticsIntegration::MetricsStorer.store('facebook_likes', count)
      end
    private
      def fetch_like_count
        oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_APP_SECRET"])
        fb_token = oauth.get_app_access_token
        @graph = Koala::Facebook::API.new(fb_token)
        page = @graph.get_object(ENV["FACEBOOK_PAGE_ID"], fields: ["fan_count"])
        count = page["fan_count"]
        puts "Facebook Page Like Count: #{count}"
        count
      end
    end
  end
end