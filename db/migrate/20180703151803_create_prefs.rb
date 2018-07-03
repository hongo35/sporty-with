class CreatePrefs < ActiveRecord::Migration[5.0]
  def change
    create_table :prefs, options: 'engine=MYISAM' do |t|
      t.string :pref_name, null: false
    end
  end
end
