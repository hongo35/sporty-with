namespace :mail do
  desc 'send'
  task send: :environment do
    UserMail.where('send_flag = 0').each do |um|
      if um.mail_type == 'event_create'
        event = Event.find_by(id: um.event_id)
        team  = Team.find_by(id: um.team_id)

        UserMailer.delivery_email(um.email, um.event_id, team.team_name, event.subject, event.start_at.strftime('%F %H:%M'), event.body).deliver
      elsif um.mail_type == 'team_apply'
        team    = Team.find_by(id: um.team_id)
        account = Account.find_by(user_id: um.user_id)

        UserMailer.apply_email(um.email, um.team_id, team.team_name, account.user_name).deliver
      end

      um.update(send_flag: 1)
    end
  end
end
