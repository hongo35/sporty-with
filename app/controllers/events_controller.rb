class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @event = Event.find_by(id: params['id'])

    tu = TeamUser.where('team_id = ? AND user_id = ? AND role != 0', @event.team_id, current_user.id).first
    redirect_to team_path(@event.team_id), alert: '閲覧権限がありません。このチームに参加申請をしてください。' if tu.blank?

    @new_comment = EventComment.new
    @comments    = EventComment.where(event_id: @event.id).order(created_at: :desc)
  end

  def new
    tu = TeamUser.find_by(team_id: params['tid'], user_id: current_user.id)

    redirect_to teams_path, danger: 'アクセスが許可されていません。' if tu.blank?

    @event = Event.new
    @team = Team.find_by(id: params['tid'])

    @today = Time.zone.now.strftime('%F')

    @select_time = [
      ['00:00', '00:00'],
      ['01:00', '01:00'],
      ['02:00', '02:00'],
      ['03:00', '03:00'],
      ['04:00', '04:00'],
      ['05:00', '05:00'],
      ['06:00', '06:00'],
      ['07:00', '07:00'],
      ['08:00', '08:00'],
      ['09:00', '09:00'],
      ['10:00', '10:00'],
      ['11:00', '11:00'],
      ['12:00', '12:00'],
      ['13:00', '13:00'],
      ['14:00', '14:00'],
      ['15:00', '15:00'],
      ['16:00', '16:00'],
      ['17:00', '17:00'],
      ['18:00', '18:00'],
      ['19:00', '19:00'],
      ['20:00', '20:00'],
      ['21:00', '21:00'],
      ['22:00', '22:00'],
      ['23:00', '23:00'],
    ]
  end

  def create
    start_at = "#{params['start_date']} #{params['start_time']}:00"
    end_at   = "#{params['end_date']} #{params['end_time']}:00"

    return redirect_to new_event_path(tid: event_params['team_id']), alert: 'タイトルを入力してください' if event_params['subject'].blank?

    e = Event.new(
      team_id: event_params['team_id'],
      user_id: current_user.id,
      subject: event_params['subject'],
      start_at: start_at,
      end_at: end_at,
      body: event_params['body']
    )

    if e.save
      uids = []
      uids = TeamUser.where('team_id = ?', event_params['team_id']).pluck(:user_id)

      to_email = []
      to_email = User.where('id IN (?)', uids).pluck(:email)

      # グループメンバーにメール送信
      UserMailer.delivery_email(to_email).deliver

      redirect_to team_path(event_params['team_id']), notice: '活動予定を作成しました'
    end
  end

  private

  def event_params
    params.require(:event).permit(:team_id, :user_id, :subject, :start_at, :end_at, :body)
  end
end
