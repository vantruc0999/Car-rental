class CreateBrands < ActiveRecord::Migration[7.1]
  def change
    create_table :brands do |t|
      t.string :name, limit: 255, comment: '車のブランド名'
      t.text :description, comment: '車のブランド説明'
      
      t.timestamps
    end
  end
end
