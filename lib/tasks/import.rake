namespace :import do
  desc '都道府県データのインポート'
  task pref: :environment do
    File.open(Rails.root.join('lib/tasks/pref.csv'), 'r') do |fp|
      fp.each_line do |row|
        Pref.create(
          pref_name: row.strip
        )
      end
    end
  end

  desc 'スポーツデータをインポート'
  task sport: :environment do
    File.open(Rails.root.join('lib/tasks/sports.csv'), 'r') do |fp|
      fp.each_line do |row|

        Sport.create(
          name: row.strip
        )
      end
    end
  end
end
