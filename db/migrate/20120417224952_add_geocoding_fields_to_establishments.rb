class AddGeocodingFieldsToEstablishments < ActiveRecord::Migration
  def change
    add_column :establishments, :lat, :decimal, :precision => 15, :scale => 10
    add_column :establishments, :lng, :decimal, :precision => 15, :scale => 10
    add_column :establishments, :postal_code, :string
    add_column :establishments, :geocoding_results_json, :text

    add_index :establishments, :lat
    add_index :establishments, :lng
  end
end
