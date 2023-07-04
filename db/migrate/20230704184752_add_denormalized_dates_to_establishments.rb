class AddDenormalizedDatesToEstablishments < ActiveRecord::Migration[7.0]
  def change
    add_column :establishments, :min_inspection_date, :date, null: true
    add_column :establishments, :max_inspection_date, :date, null: true
    add_column :establishments, :last_closed_inspection_date, :date, null: true
    add_column :establishments, :last_conditional_inspection_date, :date, null: true

    add_index :establishments, :min_inspection_date
    add_index :establishments, :max_inspection_date
    add_index :establishments, :last_closed_inspection_date
    add_index :establishments, :last_conditional_inspection_date
  end
end
