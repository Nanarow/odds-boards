# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_20_115813) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "boards", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "category_id"
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
    t.integer "visibility", default: 0
    t.index ["author_id"], name: "index_boards_on_author_id"
    t.index ["category_id"], name: "index_boards_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_categories_on_creator_id"
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.bigint "commenter_id", null: false
    t.bigint "parent_id"
    t.text "body"
    t.integer "depth", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id"], name: "index_comments_on_board_id"
    t.index ["commenter_id"], name: "index_comments_on_commenter_id"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id", "tag_id"], name: "index_taggings_on_board_id_and_tag_id", unique: true
    t.index ["board_id"], name: "index_taggings_on_board_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_tags_on_creator_id"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.string "avatar_url"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "voter_id", null: false
    t.string "votable_type", null: false
    t.bigint "votable_id", null: false
    t.boolean "is_upvote", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
    t.index ["voter_id", "votable_type", "votable_id"], name: "index_votes_on_voter_and_votable", unique: true
    t.index ["voter_id"], name: "index_votes_on_voter_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "boards", "categories"
  add_foreign_key "boards", "users", column: "author_id"
  add_foreign_key "categories", "users", column: "creator_id"
  add_foreign_key "comments", "boards"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "users", column: "commenter_id"
  add_foreign_key "taggings", "boards"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "users", column: "creator_id"
  add_foreign_key "votes", "users", column: "voter_id"
end
