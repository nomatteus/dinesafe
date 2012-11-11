class ChangeInspectionColumnTypes < ActiveRecord::Migration
  def up
    add_column :establishments, :latlng, :point
    Establishment.update_all "latlng = point(lat, lng)"
    remove_index :establishments, :lat
    remove_index :establishments, :lng
    remove_column :establishments, :lat
    remove_column :establishments, :lng

    # Don't really need this anymore.
    remove_column :establishments, :inspections_json
  end

  def down
    add_column :establishments, :lat, :decimal, :precision => 15, :scale => 10
    add_column :establishments, :lng, :decimal, :precision => 15, :scale => 10
    Establishment.update_all "lat = latlng[0], lng = latlng[1]"
    remove_column :establishments, :latlng
    add_index :establishments, :lat
    add_index :establishments, :lng

    add_column :establishments, :inspections_json, :text
  end
end
