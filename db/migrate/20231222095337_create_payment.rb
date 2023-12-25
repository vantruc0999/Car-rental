class CreatePayment < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :booking, null:false, foreign_key: { on_delete: :cascade }, comment: '予約ID'
      t.integer :amount, null:false, comment: '金額'
      t.integer :payment_status, limit: 1, unsigned: true, comment: '"0: 支払い成功 (payment successful), 1: 支払い失敗 (payment failed)"'
      t.integer :payment_method, limit: 1, unsigned: true, comment: '"0: ストライプ (stripe), 1: 銀行 (bank)"'
      t.string :stripe_session_id, null:true, comment: 'ストライプセッションID'
      t.timestamps
    end
  end
end
