class MetricsController < ApplicationController
  def index
    render json: Metric.all
  end
end
