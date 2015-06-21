class AddDeletedAtToEstablishments < ActiveRecord::Migration
  def change
    add_column :establishments, :deleted_at, :datetime
    add_index :establishments, :deleted_at
  end
end
