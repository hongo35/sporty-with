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

    @month_list = []
    (1..12).each do |i|
      @month_list << format('%02d', i)
    end

    @day_list = []
    (1..31).each do |i|
      @day_list << format('%02d', i)
    end

    @hour_list = []
    (0..23).each do |i|
      @hour_list << format('%02d', i)
    end

    now = Time.now

    @current_year  = now.strftime('%Y')
    @current_month = now.strftime('%m')
    @current_day   = now.strftime('%d')
    @current_hour  = now.strftime('%H')
  end

  def create
    datetime = "#{params['year']}-#{params['month']}-#{params['day']} #{params['hour']}:#{params['min']}:00"

    return redirect_to new_event_path(tid: event_params['team_id']), alert: 'タイトルを入力してください' if event_params['subject'].blank?

    e = Event.new(
      team_id: event_params['team_id'],
      user_id: current_user.id,
      subject: event_params['subject'],
      start_at: datetime,
      end_at: datetime,
      body: event_params['body']
    )

    if e.save
      uids = []
      uids = TeamUser.where('team_id = ?', event_params['team_id']).pluck(:user_id)

      to_emails = []
      to_emails = User.where('id IN (?)', uids).pluck(:email)

      # グループメンバーにメール送信
      to_emails.each do |to_email|
        UserMailer.delivery_email(to_email).deliver
      end

      redirect_to team_path(event_params['team_id']), notice: '活動予定を作成しました'
    end
  end

  private

  def event_params
    params.require(:event).permit(:team_id, :user_id, :subject, :start_at, :end_at, :body)
  end
end
