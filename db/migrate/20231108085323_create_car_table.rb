class CreateCarTable < ActiveRecord::Migration[7.1]
  def change
    create_table :cars do |t|
      t.references :brand, null: false, foreign_key: { on_delete: :cascade }, comment: 'brandsテーブルのID'
      t.references :car_model, null: false, foreign_key: { on_delete: :cascade }, comment: 'car_modelsテーブルのID'
      t.string :name, limit: 255, comment: '車の名前'
      t.date :year, comment: '製造年'
      t.string :color, limit: 255, comment: '車の色'
      t.integer :status, default: 0, comment: '"0: 利用可能 (available), 1: 予約済み (booked), 2: メンテナンス (maintenance)"'
      t.text :description, comment: '車の説明'
      t.string :address, limit: 255, comment: '車の住所'
      t.string :province, limit: 255, comment: '車の住所'
      t.integer :seating_capacity, comment: '車の座席数'
      t.integer :fuel_type, comment: '"0: ガソリン (petrol), 1: ディーゼル燃料 (diesel fuel), 2: 電気の (electric)"'
      t.integer :price_per_hour, null: false, comment: '車の時給料金'
      
      t.timestamps
    end
  end
end
