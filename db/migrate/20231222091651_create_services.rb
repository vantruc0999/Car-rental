class CreateServices < ActiveRecord::Migration[7.1]
  def change
    create_table :services do |t|
      t.string :name, limit: 255, comment: '名前サービス'
      t.integer :price, null: false, comment: '価格サービス' 
      t.text :description, null: true, comment: '説明サービス'
      t.timestamps
    end
  end
end
