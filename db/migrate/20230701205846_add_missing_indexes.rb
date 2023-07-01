class AddMissingIndexes < ActiveRecord::Migration[7.0]
  def up
    # This field was missing an index all along
    add_index :infractions, :inspection_id

    # This index was created in a past migration but is missing in the current db
    # (might have been lost somehow when transferring dbs, so re-create)
    execute('CREATE  INDEX "index_establishments_on_latlng" ON "establishments" USING gist ("latlng")')
  end

  def down
    remove_index :infractions, :inspection_id
    execute('DROP INDEX "index_establishments_on_latlng"')
  end
end
