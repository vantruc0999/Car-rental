class CreateCancellation < ActiveRecord::Migration[7.1]
  def change
    create_table :cancellations do |t|
      t.references :booking, null:false, foreign_key: { on_delete: :cascade }, comment: '予約ID'
      t.text :cancellation_reason, null:false, comment: '予約ID'
      t.integer :refund_amount, null:false, comment: '返金額'
      t.integer :refund_status, limit: 1, unsigned: true, comment: '""0: 保留中(pending), 1: 払い戻し成功(refund successful), 2: 払い戻し失敗(refund failed)""'
      t.timestamps
    end
  end
end
