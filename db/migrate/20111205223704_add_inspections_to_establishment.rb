class AddInspectionsToEstablishment < ActiveRecord::Migration
  def change
    add_column :establishments, :inspections_json, :text
  end
end
