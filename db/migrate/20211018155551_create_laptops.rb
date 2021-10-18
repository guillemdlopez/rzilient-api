class CreateLaptops < ActiveRecord::Migration[6.0]
  def change
    create_table :laptops do |t|
      t.string :code
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
