class MoreChanges < ActiveRecord::Migration
  # Upon further thought, it makes sense to store the "latest name" along with
  # the establishment record, for convenience. This will allow easy querying
  # for the default view, which is for up-to-date information.
  # Then, for each establishment, if different names are detected, that
  # can be shown in the expanded/historical view.
  def up
    add_column :establishments, :latest_name, :string
    add_column :establishments, :latest_type, :string

    create_table :geocodes do |t|
      t.string :address
      t.string :postal_code
      t.text :geocoding_results_json

      t.timestamps
    end
    add_column :geocodes, :latlng, :point
  end

  def down
    remove_column :establishments, :latest_name
    remove_column :establishments, :latest_type
    drop_table :geocodes
  end
end
