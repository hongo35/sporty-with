class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams, options: 'engine=MYISAM' do |t|
      t.string :name, null: false
      t.integer :sport_id, null: false
      t.string :location, null: false
      t.string :img, null: false, default: ''

      t.timestamps null: false
    end
  end
end
