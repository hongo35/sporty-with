class GroupsController < ApplicationController
  before_action  :authenticate_user!

  def index
  end

  def show
    @group = Group.find_by(id: params['id'] )

    @events = Event.where(group_id: params['id']).order(start_at: :desc)

=begin
    @events = []
    Event.where(group_id: params['id']).each do |e|
      @events << {
        'title' => e.subject,
        'start' => e.start_at.strftime('%FT%T'),
        'end'   => e.end_at.strftime('%FT%T'),
        'url'   => event_path(e.id)
      }
    end
=end
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

  def entry
    # if current_user
      
    # else
      # redirect_to 
    # end
  end

  private

  def group_params
    params.require(:group).permit(:name, :club_id, :sport_id, :img, :img_cache)
  end
end
