class AddUserInfor < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :birth_day, :date
    add_column :phone_number, :string
    add_column :province, :string
    add_column :city, :string
  end
end
