class TeamsController < ApplicationController
  # before_action  :authenticate_user!

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find_by(id: params['id'])
    @events = Event.where(team_id: params['id']).order(start_at: :desc)
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
        role: 0
      )
    end

    redirect_to home_index_path, notice: 'チームを作成しました'
  end

  private

  def team_params
    params.require(:team).permit(:private_flag, :team_name, :sport_id, :location, :img, :img_cache)
  end
end
