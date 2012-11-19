class RemoveGeocodeFieldsFromEstablishment < ActiveRecord::Migration
  def up
    remove_column :establishments, :postal_code
    remove_column :establishments, :geocoding_results_json

  end

  def down
    add_column :establishments, :postal_code, :string
    add_column :establishments, :geocoding_results_json, :text
  end
end
