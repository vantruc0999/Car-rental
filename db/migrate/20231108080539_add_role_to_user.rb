class AddRoleToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :integer, limit: 1, unsigned: true, default: 0, comment: '"0: 管理者 (user), 1: エンドユーザー (admin)"'
  end
end
