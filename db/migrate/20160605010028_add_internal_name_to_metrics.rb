class AddInternalNameToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :internal_name, :string
    add_index :metrics, :internal_name
  end
end
