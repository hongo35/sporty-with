class GroupsController < ApplicationController
  before_action  :authenticate_user!

  def index
  end

  def show
    @group = Group.find_by(id: params['id'] )
    @events = Event.where(group_id: params['id'])
  end

  def new
    @group = Group.new

    @sports = []
    Sport.all.each do |s|
      @sports << [s.name, s.id]
    end

    @clubs = []
    Club.all.each do |c|
      @clubs << [c.name, c.id]
    end
  end

  def create

    g = Group.new(group_params)

    if g.save
      GroupUser.create(
        group_id: g.id,
        user_id: current_user.id,
        role: 0
      )
    end

    redirect_to home_index_path, notice: 'グループを作成しました'
  end

  private

  def group_params
    params.require(:group).permit(:name, :club_id, :sport_id, :img)
  end
end
