require 'oauth'
require 'json'

module AnalyticsIntegration
  class Twitter
    class << self
      def populate_now
        count = fetch_followers_count
        AnalyticsIntegration::MetricsStorer.store('twitter_followers', count)
      end
    private

      def fetch_followers_count
        resp = create_access_token.request(:get, "https://api.twitter.com/1.1/users/show.json?screen_name=#{ENV['TWITTER_HANDLE']}")

        if resp.code == "200"
          count = JSON.parse(resp.body)["followers_count"].to_i
          puts "Twitter Follower Count: #{count}"
          count
        else
          throw "Expected 200 response code from Twitter API. Got #{resp.code} instead."
        end
      end

      def create_access_token
        consumer = OAuth::Consumer.new(ENV["TWITTER_CONSUMER_KEY"], ENV["TWITTER_CONSUMER_SECRET"],
          {
            site: "https://api.twitter.com",
            scheme: :header
          }
        )

        access_token = OAuth::AccessToken.from_hash(consumer, {
          oauth_token: ENV["TWITTER_ACCESS_TOKEN"],
          oauth_token_secret: ENV["TWITTER_ACCESS_SECRET"]
        })

        return access_token
      end
    end
  end
end