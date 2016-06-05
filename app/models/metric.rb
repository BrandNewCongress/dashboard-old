class Metric < ActiveRecord::Base
  has_many :metric_points

  enum status: {
    dollars: '$'
  }
end
