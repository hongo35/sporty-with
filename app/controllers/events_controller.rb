class EventsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_event, only: [:edit, :update]

  def show
    @event = Event.find_by(id: params['id'])

    @team_member_ids = TeamUser.where('team_id = ? AND role > 0', @event.team_id).pluck(:user_id)

    @team_members = {}
    Account.where('user_id IN (?)', @team_member_ids).each do |a|
      @team_members[a.user_id] = {
        'id'        => a.id,
        'user_name' => a.user_name,
        'img_url'   => a.img.url
      }
    end

    @participants = []
    EventParticipant.where('event_id = ?', @event.id).limit(20).each do |ep|
      @participants << {
        'id'        => @team_members[ep.user_id]['id'],
        'user_name' => @team_members[ep.user_id]['user_name'],
        'img_url'   => @team_members[ep.user_id]['img_url']
      }
    end

    @event_participant = EventParticipant.find_by(event_id: params['id'], user_id: current_user.id)

    tu = TeamUser.where('team_id = ? AND user_id = ? AND role != 0', @event.team_id, current_user.id).first
    redirect_to team_path(@event.team_id), alert: '閲覧権限がありません。このチームに参加申請をしてください。' if tu.blank?

    @new_comment = EventComment.new

    @comments = []
    EventComment.where(event_id: @event.id).order(created_at: :desc).each do |ec|
      id        = nil
      user_name = '名無しさん'
      img_url   = ''
      if @team_members[ec.user_id].present?
        id        = @team_members[ec.user_id]['id']
        user_name = @team_members[ec.user_id]['user_name']
        img_url   = @team_members[ec.user_id]['img_url']
      end
      
      @comments << {
        'id'         => id,
        'user_name'  => user_name,
        'img_url'    => img_url,
        'comment'    => ec.comment,
        'created_at' => ec.created_at.strftime('%-m月%-d日 %-H時%-M分')
      }
    end
  end

  def new
    tu = TeamUser.find_by(team_id: params['tid'], user_id: current_user.id)

    return redirect_to teams_path, alert: 'アクセスが許可されていません。' if tu.blank?

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

    team = Team.find_by(id: event_params['team_id'])

    if e.save
      uids = []
      uids = TeamUser.where('team_id = ?', event_params['team_id']).pluck(:user_id)

      to_emails = []
      to_emails = User.where('id IN (?)', uids).pluck(:email)

      # グループメンバーにメール送信
      to_emails.each do |to_email|
        UserMailer.delivery_email(to_email, e.id, team.team_name, event_params['subject'], datetime, event_params['body']).deliver
      end

      redirect_to team_path(event_params['team_id']), notice: '活動予定を作成しました'
    end
  end

  def edit
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

    @current_year  = @event.start_at.strftime('%Y')
    @current_month = @event.start_at.strftime('%m')
    @current_day   = @event.start_at.strftime('%d')
    @current_hour  = @event.start_at.strftime('%H')
  end

  def update
    return redirect_to edit_event_path(@event.id), alert: 'タイトルを入力してください' if event_params['subject'].blank?

    if @event.update(event_params)
      datetime = "#{params['year']}-#{params['month']}-#{params['day']} #{params['hour']}:#{params['min']}:00"
      @event.update(start_at: datetime, end_at: datetime)

      redirect_to event_path(@event.id), notice: '活動予定を更新しました。'
    else
      render :edit
    end
  end

  def participate
    EventParticipant.create(
      event_id: params['event_id'],
      user_id: current_user.id,
      user_name: current_user.name
    )

    redirect_to event_path(params['event_id']), notice: 'このイベントに参加予定です。'
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
    redirect_to root_path, alert: 'アクセスが許可されていません。' if @event.blank?

    @team = Team.find_by(id: @event.team_id)
  end

  def event_params
    params.require(:event).permit(:team_id, :user_id, :subject, :body)
  end
end
