namespace :analytics do
  desc "Load Twitter analytics (e.g. follower count) from API into Metrics DB"
  task twitter_load: :environment do
    AnalyticsIntegration::Twitter.populate_now
  end
end
