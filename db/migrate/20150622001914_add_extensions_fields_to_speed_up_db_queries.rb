class AddExtensionsFieldsToSpeedUpDbQueries < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE extension IF NOT EXISTS cube;
      CREATE extension IF NOT EXISTS earthdistance;
    SQL
    add_column :establishments, :earth_coord, :earth
    execute <<-SQL
      UPDATE establishments SET earth_coord = ll_to_earth(latlng[0], latlng[1]);
    SQL

    # Add Missing indexes
    add_index :establishments, :latest_name
    add_index :inspections, :date
  end

  def down
    execute <<-SQL
      drop extension earthdistance cascade;
      drop extension cube cascade;
    SQL
    # earth_coord column will be dropped by cascade...
    remove_index :establishments, :latest_name
    remove_index :inspections, :date
  end
end
