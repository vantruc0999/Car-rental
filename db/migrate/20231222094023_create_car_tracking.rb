class CreateCarTracking < ActiveRecord::Migration[7.1]
  def change
    create_table :car_trackings do |t|
      t.references :booking, null:false, foreign_key: { on_delete: :cascade }, comment: '予約ID'
      t.references :car, null: false, foreign_key: { on_delete: :cascade }, comment: 'ユーザーID'
      t.timestamp :return_date, null:true, comment: '返却日'
      t.integer :late_return_fee, null:true, comment: '遅延返却料金'
      t.text :late_return_reason, null: true, comment: '遅延返却理由'
      t.integer :car_tracking_status, limit: 1, comment: '"0: 期限内に車を返す(Return the car on time), 1: 車を遅れて返す(Return the car late)"'
      t.integer :payment_status, limit: 1, unsigned: true, comment: '"0: 支払い成功 (payment successful), 1: 支払い失敗 (payment failed)"'

      t.timestamps
    end
  end
end
