class TeamsController < ApplicationController
  # before_action  :authenticate_user!

  def index
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
    @club = Club.find_by(id: params['cid'])
    if @club.blank?
      redirect_to home_index_path, alert: 'スポーツクラブを選択してください'
    end
    
    # @teams = Team.where(club_id: params['cid'])
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
    params.require(:team).permit(:name, :sport_id, :location, :img, :img_cache)
  end
end
