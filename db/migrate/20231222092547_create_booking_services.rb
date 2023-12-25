class CreateBookingServices < ActiveRecord::Migration[7.1]
  def change
    create_table :booking_services do |t|
      t.references :booking, null:false, foreign_key: { on_delete: :cascade }, comment: '予約ID'
      t.references :service, null: false, foreign_key: { on_delete: :cascade }, comment: 'サービスのID'
      t.timestamps
    end
  end
end
