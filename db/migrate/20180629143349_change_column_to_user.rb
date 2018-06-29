class ChangeColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :endpoint, :string, null: false, default: '', after: :email
  end
end
