class CreateReviewTable < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, comment: 'ユーザーID'
      t.references :car, null: false, foreign_key: { on_delete: :cascade }, comment: '車両のID'
      t.references :booking, null: false, comment: '予約ID (UUID)'
      t.float :rating, comment: '評価された星の数'
      t.text :comment, comment: 'ユーザーコメント'
      t.integer :status, comment: '"0: 承認待ち (Pending), 1: 承認済み (Approved)"'

      t.timestamps
    end
  end
end
