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

ActiveRecord::Schema[7.1].define(version: 2023_12_22_095337) do
  create_table "booking_services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false, comment: "予約ID"
    t.bigint "service_id", null: false, comment: "サービスのID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_booking_services_on_booking_id"
    t.index ["service_id"], name: "index_booking_services_on_service_id"
  end

  create_table "bookings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "car_id", null: false, comment: "ユーザーID"
    t.bigint "user_id", null: false, comment: "車両のID"
    t.timestamp "booking_start", comment: "レンタル開始日"
    t.timestamp "booking_end", comment: "レンタル終了日"
    t.boolean "has_insurance", default: true, comment: "保険を購入しましたか？ True/false"
    t.integer "booking_status", default: 0, comment: "10: 予定 (Upcoming), 11: 支払い待ち (Waiting for Payment), 12: 支払い済み (Paid), 20: レンタル中 (Renting), 30: 完了 (Completed), 40: キャンセル (Canceled)"
    t.integer "car_price", comment: "車の価格"
    t.timestamp "expired_at", comment: "に期限切れになりました"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_bookings_on_car_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "brands", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", comment: "車のブランド名"
    t.text "description", comment: "車のブランド説明"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cancellations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false, comment: "予約ID"
    t.text "cancellation_reason", null: false, comment: "予約ID"
    t.integer "refund_amount", null: false, comment: "返金額"
    t.integer "refund_status", limit: 1, comment: "\"\"0: 保留中(pending), 1: 払い戻し成功(refund successful), 2: 払い戻し失敗(refund failed)\"\"", unsigned: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_cancellations_on_booking_id"
  end

  create_table "car_models", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", comment: "車種名"
    t.text "description", comment: "車種の説明"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "car_trackings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false, comment: "予約ID"
    t.bigint "car_id", null: false, comment: "ユーザーID"
    t.timestamp "return_date", comment: "返却日"
    t.integer "late_return_fee", comment: "遅延返却料金"
    t.text "late_return_reason", comment: "遅延返却理由"
    t.integer "car_tracking_status", limit: 1, comment: "\"0: 期限内に車を返す(Return the car on time), 1: 車を遅れて返す(Return the car late)\""
    t.integer "payment_status", limit: 1, comment: "\"0: 支払い成功 (payment successful), 1: 支払い失敗 (payment failed)\"", unsigned: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_car_trackings_on_booking_id"
    t.index ["car_id"], name: "index_car_trackings_on_car_id"
  end

  create_table "cars", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "brand_id", null: false, comment: "brandsテーブルのID"
    t.bigint "car_model_id", null: false, comment: "car_modelsテーブルのID"
    t.string "name", comment: "車の名前"
    t.date "year", comment: "製造年"
    t.string "color", comment: "車の色"
    t.integer "status", default: 0, comment: "\"0: 利用可能 (available), 1: 予約済み (booked), 2: メンテナンス (maintenance)\""
    t.text "description", comment: "車の説明"
    t.string "address", comment: "車の住所"
    t.string "province", comment: "車の住所"
    t.integer "seating_capacity", comment: "車の座席数"
    t.integer "fuel_type", comment: "\"0: ガソリン (petrol), 1: ディーゼル燃料 (diesel fuel), 2: 電気の (electric)\""
    t.integer "price_per_hour", null: false, comment: "車の時給料金"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_cars_on_brand_id"
    t.index ["car_model_id"], name: "index_cars_on_car_model_id"
  end

  create_table "oauth_access_grants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.string "scopes"
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "booking_id", null: false, comment: "予約ID"
    t.integer "amount", null: false, comment: "金額"
    t.integer "payment_status", limit: 1, comment: "\"0: 支払い成功 (payment successful), 1: 支払い失敗 (payment failed)\"", unsigned: true
    t.integer "payment_method", limit: 1, comment: "\"0: ストライプ (stripe), 1: 銀行 (bank)\"", unsigned: true
    t.string "stripe_session_id", comment: "ストライプセッションID"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "ユーザーID"
    t.bigint "car_id", null: false, comment: "車両のID"
    t.bigint "booking_id", null: false, comment: "予約ID (UUID)"
    t.float "rating", comment: "評価された星の数"
    t.text "comment", comment: "ユーザーコメント"
    t.integer "status", comment: "\"0: 承認待ち (Pending), 1: 承認済み (Approved)\""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["car_id"], name: "index_reviews_on_car_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", comment: "名前サービス"
    t.integer "price", null: false, comment: "価格サービス"
    t.text "description", comment: "説明サービス"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", limit: 1, default: 0, comment: "\"0: 管理者 (user), 1: エンドユーザー (admin)\"", unsigned: true
    t.string "name"
    t.date "birth_day"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "booking_services", "bookings", on_delete: :cascade
  add_foreign_key "booking_services", "services", on_delete: :cascade
  add_foreign_key "bookings", "cars", on_delete: :cascade
  add_foreign_key "bookings", "users", on_delete: :cascade
  add_foreign_key "cancellations", "bookings", on_delete: :cascade
  add_foreign_key "car_trackings", "bookings", on_delete: :cascade
  add_foreign_key "car_trackings", "cars", on_delete: :cascade
  add_foreign_key "cars", "brands", on_delete: :cascade
  add_foreign_key "cars", "car_models", on_delete: :cascade
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "payments", "bookings", on_delete: :cascade
  add_foreign_key "reviews", "cars", on_delete: :cascade
  add_foreign_key "reviews", "users", on_delete: :cascade
end
