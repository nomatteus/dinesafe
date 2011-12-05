class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.integer :establishment_id
      t.string :establishment_status
      t.integer :minimum_inspections_per_year
      t.string :infraction_details
      t.date :inspection_date
      t.string :severity
      t.string :action
      t.string :court_outcome
      t.float :amount_fined

      t.timestamps
    end
  end
end
