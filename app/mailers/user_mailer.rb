class UserMailer < ApplicationMailer
  default :charset => 'ISO-2022-JP'

  def delivery_email(to_email)
    mail(
      subject: '【スポコミュ】活動予定が作成されました。',
      to: to_email,
      from: 'スポコミュ <sports.x.community@gmail.com>'
    ) do |format|
      format.text
    end
  end

  def apply_email(to_email)
    mail(
      subject: '【スポコミュ】チームへの参加申請がありました。',
      to: to_email,
      from: 'スポコミュ <sports.x.community@gmail.com>'
    ) do |format|
      format.text
    end
  end
end
