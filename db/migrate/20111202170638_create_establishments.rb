class CreateEstablishments < ActiveRecord::Migration
  def change
    create_table :establishments do |t|
      t.string :name
      t.string :est_type  # est_type because using just 'type' breaks rails (due to magic)
      t.string :address

      t.timestamps
    end
  end
end
