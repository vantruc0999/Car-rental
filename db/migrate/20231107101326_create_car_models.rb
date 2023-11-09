class CreateCarModels < ActiveRecord::Migration[7.1]
  def change
    create_table :car_models do |t|
      t.string :name, limit: 255, comment: '車種名'
      t.text :description, comment: '車種の説明'

      t.timestamps
    end

    # Add a foreign key reference if necessary
    # For example, if you have a 'cars' table with a 'car_model_id' foreign key:
    # add_reference :cars, :car_model, foreign_key: true
  end
end
