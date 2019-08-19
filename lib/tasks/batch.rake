namespace :batch do
  desc 'LINE push通知'
  task line_push: :environment do
    client = Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.secrets.line_messaging_secret
      config.channel_token  = Rails.application.secrets.line_messaging_access_token
    }

    Event.where('start_at BETWEEN ? AND ?', (Time.zone.now + 1.day).strftime('%F 00:00:00'), (Time.zone.now + 1.day).strftime('%F 23:59:59')).each do |e|
      e.event_participants.each do |p|
        user = User.find_by(id: p.user_id, provider: 'line')
        if user.present?
          team = Team.find_by(id: e.team_id)

          message = {
            type: 'text',
            text: '明日参加予定の活動があります'
          }

          client.push_message(user.uid, message)
        end
      end
    end
  end
end
