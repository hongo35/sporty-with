class TeamsController < ApplicationController
  # before_action  :authenticate_user!
  before_action :set_team, only: [:edit, :update]

  def index
    if params[:q].present?
      # @teams = Team.query(params[:q]).where('private_flag = 0').page(params[:page]).per(params[:per])
      @teams = Team.query(params[:q])
    else
      # @teams = Team.query(params[:q]).where('private_flag = 0').page(params[:page]).per(params[:per])
      @teams = Team.all
    end
  end

  def show
    @team   = Team.find_by(id: params['id'])
    @events = Event.where(team_id: params['id']).order(start_at: :desc)

    @current_user = current_user

    @apply_cnt = 0

    if current_user.present?
      @team_user = TeamUser.where('team_id = ? AND user_id = ? AND role != 0', @team.id, current_user.id).first

      @apply_cnt = TeamUser.where('team_id = ? AND role = 0', params['id']).count
    end
  end

  def new
    return redirect_to new_user_session_path, notice: 'この操作にはログインが必要です。'  if current_user.blank?

    @team = Team.new

    @sports = []
    Sport.all.each do |s|
      @sports << [s.name, s.id]
    end
  end

  def search
    redirect_to teams_path(q: params[:q])
  end

  def create
    t = Team.new(team_params)
    t.private_flag = 0

    if t.save
      TeamUser.create(
        team_id: t.id,
        user_id: current_user.id,
        role: 1
      )

      redirect_to root_path, notice: 'チームを作成しました'
    else
      redirect_to new_team_path, alert: '必須項目を入力してください。'
    end
  end

  def edit
    @sports = []
    Sport.all.each do |s|
      @sports << [s.name, s.id]
    end
  end

  def update
    if @team.update(team_params)
      redirect_to root_path, notice: 'チームの情報を更新しました。'
    else
      render :edit
    end
  end

  def apply
    team_id = params['team_id']

    tu = TeamUser.find_by(team_id: team_id, user_id: current_user.id, role: 0)
    return redirect_to team_path(team_id), notice: 'すでに参加申請済みです。チーム管理者の承認をお待ちください。' if tu.present?

    tu_new = TeamUser.new(
      team_id: team_id,
      user_id: current_user.id,
      role: 0
    )

    if tu_new.save
      admin_uids = TeamUser.where('team_id = ?', team_id).pluck(:user_id)

      to_email = User.where('id IN (?)', admin_uids).pluck(:email)

      # グループオーナーにメール送信
      UserMailer.apply_email(to_email).deliver

      redirect_to root_path, notice: '参加申請が完了しました。管理者の承認をお待ちください。'
    end
  end

  def apply_check
    team_id = params[:tid]

    tu = TeamUser.find_by(team_id: team_id, user_id: current_user.id, role: 1)
    return redirect_to root_path, alert: '権限がありません。' if tu.blank?

    @apply_users = {}
    TeamUser.where(team_id: team_id, role: 0).each do |tu|
      u = User.find(tu.user_id)
      @apply_users[tu.id] = {
        'name'            => u.name,
        'profile_img_url' => u.profile_img_url,
        'applied_at'      => tu.created_at
      }
    end
  end

  def permit_apply
    team_user_id = params['tuid']

    tu = TeamUser.find_by(id: team_user_id)
    tu.update(role: 10)

    redirect_to apply_check_teams_path(tid: tu.team_id), notice: '参加申請を承認しました。'
  end

  private

  def set_team
    @team      = Team.find_by(id: params[:id])
    @team_user = TeamUser.find_by(team_id: params[:id], user_id: current_user.id)
    redirect_to root_path, alert: 'アクセスが許可されていません。' if @team_user.blank?
  end

  def team_params
    params.require(:team).permit(:team_name, :sport_id, :location, :img, :img_cache)
  end
end
