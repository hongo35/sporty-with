class CreateGroupUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :group_users, options: 'engine=MYISAM' do |t|
      t.integer :group_id, null: false
      t.integer :user_id, null: false
      t.integer :role, limit: 1, null: false

      t.timestamps null: false
    end
  end
end
