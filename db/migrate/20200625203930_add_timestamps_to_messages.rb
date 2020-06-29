class AddTimestampsToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :updated_at, :datetime
    add_column :messages, :created_at, :datetime
  end
end
