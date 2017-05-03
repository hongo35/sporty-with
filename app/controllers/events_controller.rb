class EventsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @event = Event.new
    @group = Group.find_by(id: params['gid'])
  end

  def create
    e = Event.new(event_params)
    e.user_id = current_user.id

    if e.save
      redirect_to group_path(event_params['group_id']), notice: '活動予定を作成しました'
    end
  end

  private

  def event_params
    params.require(:event).permit(:group_id, :user_id, :start_at, :end_at, :message)
  end
end
