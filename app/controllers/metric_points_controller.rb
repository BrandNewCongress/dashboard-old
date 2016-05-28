class MetricPointsController < ApplicationController
  def show
    render json: MetricPoint.where(metric_id: params[:id])
  end
end
