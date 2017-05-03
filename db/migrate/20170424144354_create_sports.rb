class CreateSports < ActiveRecord::Migration[5.0]
  def change
    create_table :sports, options: 'engine=MYISAM' do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
