namespace :sports do
  desc 'スポーツデータをインポート'
  task import: :environment do
    File.open(Rails.root.join('lib/tasks/sports.csv'), 'r') do |fp|
      fp.each_line do |row|

        Sport.create(
          name: row.strip
        )
      end
    end
  end
end
