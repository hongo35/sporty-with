class ChangeColumnToTeam < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :pref_id, :integer, null: false, after: :sport_id
  end
end
