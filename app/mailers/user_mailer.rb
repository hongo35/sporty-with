class UserMailer < ApplicationMailer
  default :charset => 'ISO-2022-JP'

  def delivery_email(to_email, team_name, subject, datetime, body)
    @team_name = team_name
    @subject   = subject
    @datetime  = datetime
    @body      = body

    try_cnt = 1
    begin
    mail(
      subject: '【スポコミュ】活動予定が作成されました。',
      to: to_email,
      from: 'スポコミュ <sports.x.community@gmail.com>'
    )
    rescue => e
      if try_cnt <= 3
        try_cnt += 1
        retry
      else
        fp = File.open(Rails.root.join('log/bounce.log'), 'a')
        fp.write("#{Time.now.strftime('%F %T')}\n#{to_email}\n#{e}\n\n\n")
        fp.close
      end
    end
  end

  def apply_email(to_email, team_name, user_name)
    @team_name = team_name
    @user_name = user_name

    try_cnt = 1
    begin
    mail(
      subject: '【スポコミュ】チームへの参加申請がありました。',
      to: to_email,
      from: 'スポコミュ <sports.x.community@gmail.com>'
    )
    rescue => e
      if try_cnt <= 3
        try_cnt += 1
        retry
      else
        fp = File.open(Rails.root.join('log/bounce.log'), 'a')
        fp.write("#{Time.now.strftime('%F %T')}\n#{to_email}\n#{e}\n\n\n")
        fp.close
      end
    end
  end
end
