class MoveEstablishmentNameTypeToInspection < ActiveRecord::Migration
  # But why?
  # Data Integrity: An establishment name may change, but still be at the same
  # address, so we want to keep a historical record of what the establishment
  # name was at the time of each inspection. We can still group by establishment,
  # but can show what establishment names were at each address.
  # Now that the infractions are normalized away from inspections, there won't
  # be any data repetition with establishment name/type.
  # Will re-run imports with historical xml file, then current xml file, and all
  # should be good!
  def up
    remove_column :establishments, :name
    remove_column :establishments, :est_type

    add_column :inspections, :establishment_name, :string
    add_column :inspections, :establishment_type, :string
  end

  def down
    add_column :establishments, :name, :string
    add_column :establishments, :est_type, :string

    remove_column :inspections, :establishment_name
    remove_column :inspections, :establishment_type
  end
end
