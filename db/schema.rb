# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_25_203930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "addressable_id"
    t.string "addressable_type"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "line1"
    t.string "line2"
    t.string "state"
    t.datetime "updated_at", null: false
    t.string "zip"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.bigint "attachable_id"
    t.string "attachable_type"
    t.text "attachment_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "authentication_tokens", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "last_used_at"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_authentication_tokens_on_user_id"
  end

  create_table "data_migrations", id: :serial, force: :cascade do |t|
    t.string "version"
  end

  create_table "images", force: :cascade do |t|
    t.bigint "attachable_id"
    t.string "attachable_type"
    t.datetime "created_at", null: false
    t.text "image_data"
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_images_on_attachable_type_and_attachable_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at"
    t.string "message"
    t.datetime "updated_at"
    t.bigint "user_id"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "access_token"
    t.datetime "access_token_expiration"
    t.text "apn_key"
    t.string "apn_key_id"
    t.string "auth_key"
    t.string "bundle_id"
    t.text "certificate"
    t.string "client_id"
    t.string "client_secret"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.string "environment"
    t.boolean "feedback_enabled", default: true
    t.string "name", null: false
    t.string "password"
    t.string "team_id"
    t.string "type", null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.integer "app_id"
    t.datetime "created_at", precision: 6, null: false
    t.string "device_token"
    t.datetime "failed_at", null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.text "alert"
    t.boolean "alert_is_json", default: false, null: false
    t.integer "app_id", null: false
    t.integer "badge"
    t.string "category"
    t.string "collapse_key"
    t.boolean "content_available", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.text "data"
    t.boolean "delay_while_idle", default: false, null: false
    t.datetime "deliver_after"
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.string "device_token"
    t.boolean "dry_run", default: false, null: false
    t.integer "error_code"
    t.text "error_description"
    t.integer "expiry", default: 86400
    t.string "external_device_id"
    t.datetime "fail_after"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.boolean "mutable_content", default: false, null: false
    t.text "notification"
    t.integer "priority"
    t.boolean "processing", default: false, null: false
    t.text "registration_ids"
    t.integer "retries", default: 0
    t.string "sound"
    t.string "thread_id"
    t.string "type", null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uri"
    t.text "url_args"
    t.index ["delivered", "failed", "processing", "deliver_after", "created_at"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "users", force: :cascade do |t|
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.inet "current_sign_in_ip"
    t.datetime "deleted_at"
    t.string "device_token"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.datetime "invitation_accepted_at"
    t.datetime "invitation_created_at"
    t.integer "invitation_limit"
    t.datetime "invitation_sent_at"
    t.string "invitation_token"
    t.integer "invitations_count", default: 0
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.inet "last_sign_in_ip"
    t.string "photo_data"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "roles_mask"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.index "email, COALESCE(deleted_at, 'infinity'::timestamp without time zone)", name: "index_users_on_email_and_deleted_at", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "authentication_tokens", "users"
end
