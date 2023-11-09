class CreateBookingTable < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :car, null: false, foreign_key: { on_delete: :cascade }, comment: 'ユーザーID'
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, comment: '車両のID'
      t.timestamp :booking_start, comment: 'レンタル開始日'
      t.timestamp :booking_end, comment: 'レンタル終了日'
      t.boolean :has_insurance, default: true, comment: '保険を購入しましたか？ True/false'
      t.integer :booking_status, default: 0, comment: '10: 予定 (Upcoming), 11: 支払い待ち (Waiting for Payment), 12: 支払い済み (Paid), 20: レンタル中 (Renting), 30: 完了 (Completed), 40: キャンセル (Canceled)'
      t.integer :car_price, comment: '車の価格'
      t.timestamp :expired_at, comment: 'に期限切れになりました'
  
      t.timestamps
    end
  end
end
