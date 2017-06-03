class EventCommentsController < ApplicationController
  def create
    ec = EventComment.new(event_comment_params)

    if ec.save
      redirect_to event_path(ec.event_id), notice: 'コメントを投稿しました'
    else
      redirect_to event_path(event_comment_params['event_id']), alert: '投稿に失敗しました'
    end
  end

  def event_comment_params
    params.require(:event_comment).permit(:event_id, :user_id, :user_name, :comment)
  end
end
