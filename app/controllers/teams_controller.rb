require 'digest/md5'

class TeamsController < ApplicationController
  # before_action  :authenticate_user!
  before_action :search_list, only: [:index, :new, :edit]
  before_action :set_team, only: [:edit, :update, :invite_member]

  def index
    @q = ''
    @sport_label = ''
    @pref_label = ''
    if params[:q].present?
      @teams = Team.query(params[:q])
      @q = params[:q]
    elsif params[:pref_id].present?
      @teams = Team.where('pref_id = ?', params[:pref_id])
      @pref_label = @prefs[params[:pref_id].to_i - 1][0]
    elsif params[:sport_id].present?
      @teams = Team.where('sport_id = ?', params[:sport_id])
      @sport_label = @sports[params[:sport_id].to_i - 1][0]
    else
      @teams = Team.all
    end
  end

  def show
    @team   = Team.find_by(id: params['id'])
    @events = Event.where(team_id: params['id']).order(start_at: :desc)

    @current_user = current_user

    @apply_cnt = 0

    @team_members = []
    TeamUser.where('team_id = ? AND role > 0', @team.id).each do |tu|
      account = Account.find_by(user_id: tu.user_id)

      img_url = account.img.url
      if img_url.blank?
        user = User.find_by(id: tu.user_id)
        img_url = user.profile_img_url
      end

      @team_members << {
        'id'        => account.id,
        'user_name' => account.user_name,
        'img_url'   => img_url
      }
    end

    if current_user.present?
      @team_user = TeamUser.where('team_id = ? AND user_id = ? AND role > 0', @team.id, current_user.id).first

      @apply_user = TeamUser.find_by(team_id: @team.id, user_id: current_user.id, role: 0)

      @apply_cnt = TeamUser.where('team_id = ? AND role = 0', params['id']).count
    end
  end

  def invite_member
    @tid_h = Digest::MD5.new.update(@team.id.to_s).to_s[5...25]
  end

  def new
    return redirect_to new_user_session_path, notice: 'この操作にはログインが必要です。'  if current_user.blank?

    @team = Team.new
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

    team = Team.find_by(id: team_id)

    if tu_new.save
      admin_uids = TeamUser.where('team_id = ? AND role = 1', team_id).pluck(:user_id)

      admin_uids.each do |uid|
        if uid != current_user.id
          Timeline.create(
            read_status: 0,
            user_id: uid,
            team_id: team_id,
            event_id: 0,
            action_type: 'team_apply',
            action_user_id: current_user.id,
            comment: ''
          )
        end
      end

      to_emails = User.where('id IN (?)', admin_uids).pluck(:email)

      # グループオーナーにメール送信
      to_emails.each do |to_email|
        UserMail.create(
          send_flag: 0,
          mail_type: 'team_apply',
          email: to_email,
          user_id: current_user.id,
          team_id: team_id,
          event_id: nil
        )
      end

      redirect_to root_path, notice: '参加申請が完了しました。管理者の承認をお待ちください。'
    end
  end

  def apply_check
    team_id = params[:id]

    tu = TeamUser.find_by(team_id: team_id, user_id: current_user.id, role: 1)
    return redirect_to root_path, alert: '権限がありません。' if tu.blank?

    @apply_users = {}
    TeamUser.where(team_id: team_id, role: 0).each do |tu|
      a = Account.find_by(user_id: tu.user_id)
      @apply_users[tu.id] = {
        'account_id'      => a.id,
        'name'            => a.user_name,
        'profile_img_url' => a.img.url,
        'applied_at'      => tu.created_at
      }
    end
  end

  def permit_apply
    team_user_id = params['tuid']

    tu = TeamUser.find_by(id: team_user_id)
    tu.update(role: 10)

    Timeline.create(
      read_status: 0,
      user_id: tu.user_id,
      team_id: tu.team_id,
      event_id: 0,
      action_type: 'team_apply_permit',
      action_user_id: current_user.id,
      comment: ''
    )

    redirect_to apply_check_team_path(tu.team_id), notice: '参加申請を承認しました。'
  end

  def forbid_apply
    team_user_id = params['tuid']

    tu = TeamUser.find_by(id: team_user_id)
    tu.update(role: -1)

    redirect_to apply_check_teams_path(tid: tu.team_id), alert: '参加申請をキャンセルしました。'
  end

  private

  def search_list
    @sports = []
    Sport.all.each do |s|
      @sports << [s.name, s.id]
    end

    @prefs = []
    Pref.all.each do |p|
      @prefs << [p.pref_name, p.id]
    end
  end

  def set_team
    @team      = Team.find_by(id: params[:id])
    @team_user = TeamUser.where('team_id = ? AND user_id = ? AND role > 0', params[:id], current_user.id).first
    redirect_to root_path, alert: 'アクセスが許可されていません。' if @team_user.blank?
  end

  def team_params
    params.require(:team).permit(:team_name, :sport_id, :pref_id, :location, :img, :img_cache, :body)
  end
end
