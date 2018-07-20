class CreateTimelines < ActiveRecord::Migration[5.0]
  def change
    create_table :timelines, options: 'engine=MYISAM' do |t|
      t.integer :read_status, null: false
      t.integer :user_id, null: false
      t.integer :team_id, null: false
      t.integer :event_id, null: false
      t.string :action_type, null: false
      t.integer :action_user_id, null: false
      t.text :comment, null: false

      t.timestamps null: false
    end
  end
end
