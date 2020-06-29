class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true
      t.string :city
      t.string :line1
      t.string :line2
      t.string :state
      t.string :zip

      t.timestamps
    end
  end
end
