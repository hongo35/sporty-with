class CreateEventParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :event_participants, options: 'engine=MYISAM' do |t|
      t.integer :event_id, null: false
      t.integer :user_id, null: false
      t.string :user_name, null: false

      t.timestamps null: false

      t.index :event_id
    end
  end
end
