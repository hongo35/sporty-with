class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts, options: 'engine=MYISAM' do |t|
      t.integer :user_id, null: false
      t.string :user_name, null: false
      t.string :img, null: false, default: ''

      t.timestamps null: false
    end
  end
end
