class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :name
      t.text :description

      t.timestamps null: false
    end
  end
end
