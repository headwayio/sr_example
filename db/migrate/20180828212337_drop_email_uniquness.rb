class DropEmailUniquness < ActiveRecord::Migration[5.2]
  def up
    remove_index :users, name: 'index_users_on_email'
    execute <<-SQL.squish
      CREATE UNIQUE INDEX  "index_users_on_email_and_deleted_at" ON "users"
          ("email", COALESCE(deleted_at, timestamp 'infinity'))
    SQL
  end

  def down
    remove_index :users, name: 'index_users_on_email_and_deleted_at'
    add_index :users, :email, unique: true
  end
end
