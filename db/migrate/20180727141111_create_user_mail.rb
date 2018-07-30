class CreateUserMail < ActiveRecord::Migration[5.0]
  def change
    create_table :user_mails, options: 'engine=MYISAM' do |t|
      t.integer :send_flag, null: false, limit: 1
      t.string :mail_type, null: false
      t.string :email, null: false
      t.integer :user_id, null: false
      t.integer :team_id, null: false
      t.integer :event_id

      t.timestamps null: false
    end
  end
end
