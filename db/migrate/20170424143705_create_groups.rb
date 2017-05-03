class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups, options: 'engine=MYISAM' do |t|
      t.integer :club_id, null: false
      t.string :name, null: false
      t.integer :sport_id, null: false
      t.string :img, null: false

      t.timestamps null: false
    end
  end
end
