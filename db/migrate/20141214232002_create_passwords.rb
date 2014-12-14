class CreatePasswords < ActiveRecord::Migration
  def change
    create_table :passwords do |t|
      t.integer :count

      t.timestamps null: false
    end
  end
end
