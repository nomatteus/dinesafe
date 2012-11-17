class AddIndexesToEstablishmentsAndInspections < ActiveRecord::Migration
  def up
    add_index :establishments, :name
    execute('CREATE  INDEX "index_establishments_on_latlng" ON "establishments" USING gist ("latlng")')

    add_index :inspections, :establishment_id
  end

  def down
    remove_index :establishments, :name
    execute('DROP INDEX "index_establishments_on_latlng"')

    remove_index :inspections, :establishment_id
  end
end
