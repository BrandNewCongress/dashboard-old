require 'oauth'
require 'json'

module AnalyticsIntegration
  class NationBuilder
    RESULTS_PER_PAGE = 50

    class << self
      def populate_now(
        start_date = Util::DateUtil.eastern_time_days_ago(1),
        end_date = Util::DateUtil.eastern_time_days_ago(1)
      )
        count = fetch_and_store_donations(start_date, end_date)
        # AnalyticsIntegration::MetricsStorer.store('twitter_followers', count)
      end
    private

      def fetch_and_store_donations(start_date, end_date)
        start_time = Util::DateUtil.eastern_time_start_of_day(start_date)
        end_time = Util::DateUtil.eastern_time_end_of_date(end_date)

        get_request("/api/v1/donations") do |resp|
          if resp.code == "200"
            process_success_response(resp, 1, start_time, end_time)
          else
            puts "Fetch donations page failed."
          end
        end
      end

      def store_metrics(metrics)
        metrics.each do |metrics_for_day|
          puts "Storing NationBuilder metrics for #{metrics_for_day[:day]}..."

          utc_day = Util::DateUtil.utc_parse_day(metrics_for_day[:day])
          AnalyticsIntegration::MetricsStorer.store('average_per_donor', metrics_for_day[:amount_per_donor], utc_day)
          AnalyticsIntegration::MetricsStorer.store('donors', metrics_for_day[:donors], utc_day)
          AnalyticsIntegration::MetricsStorer.store('funds_raised', metrics_for_day[:amount], utc_day)

          puts "Stored NationBuilder metrics for #{metrics_for_day[:day]}..."
        end
      end

      def extract_metrics(grouped_donations)
        grouped_donations.map do |day, donations|
          amount = donations.reduce(0) {|a, e| a + e[:amount] }
          donors = donations.map {|d| d[:donor_id] }.uniq.count
          amount_per_donor = amount / donors

          { day: day, amount: amount, donors: donors, amount_per_donor: amount_per_donor }
        end
      end

      def process_success_response(resp, page_no, start_time, end_time, grouped_donations = {})
        puts "Fetched page #{page_no} of donations."

        parsed_body = JSON.parse(resp.body)
        raw_donations = parsed_body["results"]

        puts "Processing #{raw_donations.length} donation(s)."

        processed_page = process_raw_donations(raw_donations, start_time, end_time, grouped_donations)

        if processed_page[:before_start_time?]
          metrics = extract_metrics(processed_page[:grouped_donations])
          store_metrics(metrics)
        else
          # fetch next page
          get_request(parsed_body["next"], true) do |next_resp|
            process_success_response(next_resp, page_no + 1, start_time, end_time, processed_page[:grouped_donations])
          end
        end
      end

      def process_raw_donations(donations, start_time, end_time, grouped_donations)
        result = {}
        result[:before_start_time?] = false
        result[:grouped_donations] = grouped_donations

        donations.each do |donation|
          donation_time = DateTime.parse(donation["created_at"])

          if donation_time < start_time
            result[:before_start_time?] = true
          elsif donation_time < end_time
            donation_info = {}
            donation_info[:amount] = donation["amount_in_cents"] / 100.0
            donation_info[:donor_id] = donation["donor_id"]

            et_day = Util::DateUtil.eastern_day_string(donation_time)

            result[:grouped_donations][et_day] ||= []
            result[:grouped_donations][et_day] << donation_info
          end
        end

        result
      end

      def get_request(path, has_params = false, &block)
        req_uri = URI("#{origin}#{path}")

        params = req_uri.query ? URI.decode_www_form(req_uri.query) : []
        params << ["access_token", token]
        params << ["limit", RESULTS_PER_PAGE]

        req_uri.query = URI.encode_www_form(params)

        req = Net::HTTP::Get.new(req_uri)
        req['Content-type'] = req['Accept'] = 'application/json'

        res = Net::HTTP.start(req_uri.hostname, req_uri.port, { use_ssl: true }) do |http|
          http.request(req) do |resp|
            block.call(resp)
          end
        end
      end

      def origin
        "https://#{slug}.nationbuilder.com"
      end

      def slug
        ENV['NATIONBUILDER_SUBDOMAIN']
      end

      def token
        ENV['NATIONBUILDER_TOKEN']
      end
    end
  end
end