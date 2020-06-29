class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true
      t.text :attachment_data

      t.timestamps
    end
  end
end
