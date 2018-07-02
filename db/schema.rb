# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180309102139) do

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "link"
    t.string "name"
    t.string "title"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images_posts", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "image_id", null: false
    t.bigint "post_id", null: false
    t.string "link_name"
    t.index ["image_id"], name: "index_images_posts_on_image_id"
    t.index ["post_id"], name: "index_images_posts_on_post_id"
  end

  create_table "post_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "content"
    t.bigint "post_id"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_contents_on_post_id"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.text "excerpt"
    t.datetime "datetime_of_placement"
    t.integer "source_type"
    t.integer "visability_mode", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cover_id"
    t.index ["cover_id"], name: "index_posts_on_cover_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username", null: false
    t.string "password", null: false
    t.string "email"
    t.boolean "admin", default: false
  end

  add_foreign_key "post_contents", "posts", on_delete: :cascade
  add_foreign_key "posts", "images", column: "cover_id", on_delete: :nullify
end
