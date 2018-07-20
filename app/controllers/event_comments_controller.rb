class EventCommentsController < ApplicationController
  def create
    ec = EventComment.new(event_comment_params)

    uids = []
    uids = TeamUser.where('team_id = ?', event_comment_params['team_id']).pluck(:user_id)

    uids.each do |uid|
      if uid != event_comment_params['user_id'].to_i
        Timeline.create(
          read_status: 0,
          user_id: uid,
          team_id: event_comment_params['team_id'],
          event_id: event_comment_params['event_id'],
          action_type: 'event_comment',
          action_user_id: event_comment_params['user_id'],
          comment:  event_comment_params['comment']
        )
      end
    end

    if ec.save
      redirect_to event_path(ec.event_id), notice: 'コメントを投稿しました'
    else
      redirect_to event_path(event_comment_params['event_id']), alert: '投稿に失敗しました'
    end
  end

  def event_comment_params
    params.require(:event_comment).permit(:event_id, :team_id, :user_id, :user_name, :comment)
  end
end
