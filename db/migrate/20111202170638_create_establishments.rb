class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.string :name
      t.string :est_type
      t.string :address

      t.timestamps
    end
  end
end
