class CreateClubs < ActiveRecord::Migration[5.0]
  def change
    create_table :clubs, options: 'engine=MYISAM' do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.string :address, null: false

      t.timestamps null: false
    end
  end
end
