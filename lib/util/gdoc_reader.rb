require 'csv'

module Util
  class GdocReader
    SERIES = [
      "CCs",
      "CC Attendees",
      "Active Callers",
      "1:1 Calls dialed",
      "1:1 Calls completed",
      "Facebook likes",
      "FB daily like gain",
      "FB engagment (Daily)",
      "Daily Vol sign ups",
      "Daily Web sign ups",
      "Twitter followers",
      "Donors",
      "Funds raised",
      "Average per donor"
    ]

    def self.read
      rows = CSV.read('metrics.csv')

      extracted = SERIES.map {|s| { name: s, points: self.extract_serie(s, rows) } }
      extracted.each do |s|
        m = Metric.new
        m.name = s[:name]
        m.save

        s[:points].each do |p|
          mp = MetricPoint.new
          mp.metric = m
          mp.datetime = p[:datetime]
          mp.value = p[:value]
          mp.save
        end
      end
    end

    def self.extract_serie(serie_name, rows)
      header_row = rows[0]

      index = header_row.index(serie_name)
      rows[1..-1].map do |row|
        datetime = Date.strptime(row[0], "%m/%d/%Y")
        value = BigDecimal.new(row[index].tr('/$,.', '')).to_f if row[index]
        { datetime: datetime, value: value } if value
      end.compact
    end
  end
end