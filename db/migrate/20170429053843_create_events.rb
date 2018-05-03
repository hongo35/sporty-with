class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events, options: 'engine=MYISAM' do |t|
      t.integer :team_id, null: false
      t.integer :user_id , null: false
      t.string :subject, null: false, default: ''
      t.datetime :start_at
      t.datetime :end_at
      t.text :body

      t.timestamps null: false
    end
  end
end
