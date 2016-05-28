class AddIndexToMetricPoints < ActiveRecord::Migration
  def change
    add_index :metric_points, [:metric_id, :datetime]
  end
end
