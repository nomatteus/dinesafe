class RemoveInspectionsInspectionId < ActiveRecord::Migration
  # This is redundant now. Use id field as inspection ID (now that we have
  # inspection IDs for everything)
  def up
    remove_column :inspections, :inspection_id
  end

  def down
    add_column :inspections, :inspection_id, :integer, :blank => false
  end
end
