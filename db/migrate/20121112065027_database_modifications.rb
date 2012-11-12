class DatabaseModifications < ActiveRecord::Migration
  def change
    rename_column :inspections, :establishment_status, :status
    rename_column :inspections, :inspection_date, :date
  end
end
