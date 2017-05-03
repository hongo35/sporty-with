namespace :clubs do
  desc '東京都のスポーツクラブデータをインポート'
  task import: :environment do
    File.open(Rails.root.join('lib/tasks/tokyo_clubs.csv'), 'r') do |fp|
      fp.each_line do |row|
        rsp = row.split(',')

        Club.create(
          name: rsp[0].strip,
          url: rsp[1].strip,
          address: rsp[2].strip
        )
      end
    end
  end
end
