class RemoveInfractionFieldsFromInspections < ActiveRecord::Migration
  def up
    remove_column :inspections, :infraction_details
    remove_column :inspections, :severity
    remove_column :inspections, :action
    remove_column :inspections, :court_outcome
    remove_column :inspections, :amount_fined
  end

  def down 
    change_table :inspections do |t|
      t.string :infraction_details
      t.string :severity
      t.string :action
      t.string :court_outcome
      t.float :amount_fined
    end
  end
end
