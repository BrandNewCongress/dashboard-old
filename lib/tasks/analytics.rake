namespace :analytics do
  desc "Load Twitter analytics (e.g. follower count) from API into Metrics DB"
  task twitter_load: :environment do
    AnalyticsIntegration::Twitter.populate_now
  end

  desc "Load Facebook analytics (e.g. page like count) from API into Metrics DB"
  task facebook_load: :environment do
    AnalyticsIntegration::Facebook.populate_now
  end

  desc "Load NationBuilder analytics (e.g. donations) from API into Metrics DB"
  task nb_load: :environment do
    AnalyticsIntegration::NationBuilder.populate_now
  end
end
