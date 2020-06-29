class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.references :attachable, polymorphic: true
      t.text :image_data

      t.timestamps
    end
  end
end
