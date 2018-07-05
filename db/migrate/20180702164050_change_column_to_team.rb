class ChangeColumnToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :body, :text, null: false, after: :img
  end
end
