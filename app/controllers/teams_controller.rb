class TeamsController < ApplicationController
  # before_action  :authenticate_user!

  def index
    if params[:q].present?
      # @teams = Team.query(params[:q]).where('private_flag = 0').page(params[:page]).per(params[:per])
      @teams = Team.query(params[:q]).where('private_flag = 0')
    else
      # @teams = Team.query(params[:q]).where('private_flag = 0').page(params[:page]).per(params[:per])
      @teams = Team.where('private_flag = 0')
    end
  end

  def show
    @team      = Team.find_by(id: params['id'])
    @events    = Event.where(team_id: params['id']).order(start_at: :desc)

    @current_user = current_user

    if current_user.present?
      @team_user = TeamUser.find_by(team_id: @team.id, user_id: current_user.id)
    end
  end

  def new
    @team = Team.new

    @sports = []
    Sport.all.each do |s|
      @sports << [s.name, s.id]
    end

    @clubs = []
    Club.all.each do |c|
      @clubs << [c.name, c.id]
    end
  end

  def search
    redirect_to teams_path(q: params[:q])
  end

  def create
    t = Team.new(team_params)

    if t.save
      TeamUser.create(
        team_id: t.id,
        user_id: current_user.id,
        role: 1
      )
    end

    redirect_to home_index_path, notice: 'チームを作成しました'
  end

  def apply
    team_id = params['team_id']

    tu = TeamUser.new(
      team_id: team_id,
      user_id: current_user.id,
      role: 0
    )

    if tu.save
      admin_uids = TeamUser.where('team_id = ?', team_id).pluck(:user_id)

      to_email = User.where('id IN (?)', admin_uids).pluck(:email)

      # グループオーナーにメール送信
      UserMailer.apply_email(to_email).deliver

      redirect_to team_path(team_id), notice: '参加申請完了'
    end
  end

  private

  def team_params
    params.require(:team).permit(:private_flag, :team_name, :sport_id, :location, :img, :img_cache)
  end
end
