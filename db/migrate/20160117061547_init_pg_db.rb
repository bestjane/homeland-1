# frozen_string_literal: true

class InitPgDb < ActiveRecord::Migration[4.2]
  def change
    create_table "authorizations", force: :cascade do |t|
      t.string   "provider", limit: 100, null: false
      t.string   "uid", limit: 100, null: false
      t.integer  "user_id", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "authorizations", %w(provider uid), name: "index_authorizations_on_provider_and_uid", using: :btree

    create_table "comments", force: :cascade do |t|
      t.text     "body", null: false
      t.text     "body_html"
      t.integer  "user_id", null: false
      t.string   "commentable_type", limit: 100
      t.integer  "commentable_id"
      t.datetime "deleted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
    add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
    add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

    create_table "exception_logs", force: :cascade do |t|
      t.string   "title",      null: false
      t.text     "body",       null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "locations", force: :cascade do |t|
      t.string   "name",                    null: false, limit: 100
      t.integer  "users_count", default: 0, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

    create_table "nodes", force: :cascade do |t|
      t.string   "name",                     null: false
      t.string   "summary"
      t.integer  "section_id",               null: false
      t.integer  "sort",         default: 0, null: false
      t.integer  "topics_count", default: 0, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "nodes", ["section_id"], name: "index_nodes_on_section_id", using: :btree

    create_table "notes", force: :cascade do |t|
      t.string   "title",                         null: false
      t.text     "body",                          null: false
      t.integer  "user_id",                       null: false
      t.integer  "word_count",    default: 0,     null: false
      t.integer  "changes_count", default: 0,     null: false
      t.boolean  "publish",       default: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

    create_table "notifications", force: :cascade do |t|
      t.integer  "user_id", null: false
      t.boolean  "read", default: false
      t.string   "type"
      t.integer  "follower_id"
      t.integer  "node_id"
      t.integer  "topic_id"
      t.integer  "reply_id"
      t.integer  "mentionable_id"
      t.string   "mentionable_type"
      t.integer  "mentioned_user_ids", default: [], array: true
      t.integer  "changes_count",      default: 0, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "notifications", ["read"], name: "index_notifications_on_read", using: :btree
    add_index "notifications", %w(user_id read), name: "index_notifications_on_user_id_and_read", using: :btree

    create_table "oauth_access_grants", force: :cascade do |t|
      t.integer  "resource_owner_id", null: false
      t.integer  "application_id",    null: false
      t.string   "token",             null: false, limit: 200
      t.integer  "expires_in",        null: false
      t.text     "redirect_uri",      null: false
      t.datetime "created_at",        null: false
      t.datetime "revoked_at"
      t.string   "scopes"
    end

    add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

    create_table "oauth_access_tokens", force: :cascade do |t|
      t.integer  "resource_owner_id"
      t.integer  "application_id"
      t.string   "token", null: false, limit: 200
      t.string   "refresh_token", limit: 200
      t.integer  "expires_in"
      t.datetime "revoked_at"
      t.datetime "created_at", null: false
      t.string   "scopes"
    end

    add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

    create_table "oauth_applications", force: :cascade do |t|
      t.string   "name",                      null: false
      t.string   "uid",                       null: false, limit: 200
      t.string   "secret",                    null: false
      t.text     "redirect_uri",              null: false
      t.string   "scopes", default: "", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "owner_id"
      t.string   "owner_type", limit: 200
    end

    add_index "oauth_applications", %w(owner_id owner_type), name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
    add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

    create_table "page_versions", force: :cascade do |t|
      t.integer  "user_id",                null: false
      t.integer  "page_id",                null: false
      t.integer  "version", default: 0, null: false
      t.string   "slug",                   null: false
      t.string   "title",                  null: false
      t.text     "desc",                   null: false
      t.text     "body",                   null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "page_versions", %w(page_id version), name: "index_page_versions_on_page_id_and_version", using: :btree
    add_index "page_versions", ["page_id"], name: "index_page_versions_on_page_id", using: :btree

    create_table "photos", force: :cascade do |t|
      t.integer  "user_id"
      t.string   "image", null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "replies", force: :cascade do |t|
      t.integer  "user_id",                         null: false
      t.integer  "topic_id",                        null: false
      t.text     "body",                            null: false
      t.text     "body_html"
      t.integer  "state",              default: 1, null: false
      t.integer  "liked_user_ids",     default: [], array: true
      t.integer  "likes_count",        default: 0
      t.integer  "mentioned_user_ids", default: [], array: true
      t.datetime "deleted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "replies", ["topic_id"], name: "index_replies_on_topic_id", using: :btree
    add_index "replies", ["user_id"], name: "index_replies_on_user_id", using: :btree

    create_table "sections", force: :cascade do |t|
      t.string   "name",                   null: false, limit: 200
      t.integer  "sort", default: 0, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "sections", ["sort"], name: "index_sections_on_sort", using: :btree

    create_table "site_configs", force: :cascade do |t|
      t.string   "key",        null: false
      t.text     "value",      null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "site_configs", ["key"], name: "index_site_configs_on_key", using: :btree

    create_table "topics", force: :cascade do |t|
      t.integer  "user_id",                            null: false
      t.integer  "node_id",                            null: false
      t.string   "title",                              null: false, limit: 255
      t.text     "body",                               null: false
      t.text     "body_html"
      t.integer  "last_reply_id"
      t.integer  "last_reply_user_id"
      t.string   "last_reply_user_login", limit: 255
      t.string   "node_name", limit: 255
      t.string   "who_deleted", limit: 255
      t.integer  "last_active_mark"
      t.boolean  "lock_node", default: false
      t.datetime "suggested_at"
      t.integer  "excellent", default: 0
      t.datetime "replied_at"
      t.integer  "replies_count",      default: 0, null: false
      t.integer  "likes_count",        default: 0
      t.integer  "follower_ids",       default: [],                 array: true
      t.integer  "liked_user_ids",     default: [],                 array: true
      t.integer  "mentioned_user_ids", default: [],                 array: true
      t.datetime "deleted_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "topics", ["excellent"], name: "index_topics_on_excellent", using: :btree
    add_index "topics", ["last_active_mark"], name: "index_topics_on_last_active_mark", using: :btree
    add_index "topics", ["likes_count"], name: "index_topics_on_likes_count", using: :btree
    add_index "topics", ["node_id"], name: "index_topics_on_node_id", using: :btree
    add_index "topics", ["suggested_at"], name: "index_topics_on_suggested_at", using: :btree
    add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree

    create_table "users", force: :cascade do |t|
      t.string   "login",                                  null: false, limit: 255
      t.string   "name",                                   null: false, limit: 255
      t.string   "email",                                  null: false, limit: 255
      t.string   "email_md5",                              null: false, limit: 255
      t.boolean  "email_public", default: false, null: false
      t.string   "location", limit: 255
      t.integer  "location_id"
      t.string   "bio", limit: 255
      t.string   "website", limit: 255
      t.string   "company", limit: 255
      t.string   "github", limit: 255
      t.string   "twitter", limit: 255
      t.string   "qq", limit: 255
      t.string   "avatar", limit: 255
      t.boolean  "verified",               default: false, null: false
      t.boolean  "hr",                     default: false, null: false
      t.integer  "state",                  default: 1,     null: false
      t.string   "tagline", limit: 255
      t.string   "co", limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "encrypted_password", default: "", null: false, limit: 255
      t.string   "reset_password_token", limit: 255
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count", default: 0, null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string   "current_sign_in_ip", limit: 255
      t.string   "last_sign_in_ip", limit: 255
      t.string   "password_salt",          default: "",    null: false, limit: 255
      t.string   "persistence_token",      default: "",    null: false, limit: 255
      t.string   "single_access_token",    default: "",    null: false, limit: 255
      t.string   "perishable_token",       default: "",    null: false, limit: 255
      t.integer  "topics_count",           default: 0,     null: false
      t.integer  "replies_count",          default: 0,     null: false
      t.string   "private_token"
      t.integer  "favorite_topic_ids",     default: [],                 array: true
      t.integer  "blocked_node_ids",       default: [],                 array: true
      t.integer  "blocked_user_ids",       default: [],                 array: true
      t.integer  "following_ids",          default: [],                 array: true
      t.integer  "follower_ids",           default: [],                 array: true
    end

    add_index "users", ["email"], name: "index_users_on_email", using: :btree
    add_index "users", ["location"], name: "index_users_on_location", using: :btree
    add_index "users", ["login"], name: "index_users_on_login", using: :btree
    add_index "users", ["private_token"], name: "index_users_on_private_token", using: :btree
  end
end
