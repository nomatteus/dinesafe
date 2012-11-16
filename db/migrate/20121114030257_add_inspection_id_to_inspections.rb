class AddInspectionIdToInspections < ActiveRecord::Migration
  def change
    add_column :inspections, :inspection_id, :integer, :blank => false
  end
end
