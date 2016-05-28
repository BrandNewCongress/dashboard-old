class CreateMetricPoints < ActiveRecord::Migration
  def change
    create_table :metric_points do |t|
      t.references :metric, index: true, foreign_key: true
      t.datetime :datetime
      t.decimal :value

      t.timestamps null: false
    end
  end
end
