class EventReportsController < ApplicationController
  def create
    er = EventReport.new(event_report_params)

    uids = []
    uids = TeamUser.where('team_id = ?', event_report_params['team_id']).pluck(:user_id)

    uids.each do |uid|
      if uid != event_report_params['user_id'].to_i
        Timeline.create(
          read_status: 0,
          user_id: uid,
          team_id: event_report_params['team_id'],
          event_id: event_report_params['event_id'],
          action_type: 'event_report',
          action_user_id: event_report_params['user_id'],
          comment:  event_report_params['body']
        )
      end
    end

    if er.save
      redirect_to report_event_path(er.event_id), notice: 'レポートを投稿しました'
    else
      redirect_to event_path(event_report_params['event_id']), alert: '投稿に失敗しました'
    end
  end

  def event_report_params
    params.require(:event_report).permit(:event_id, :team_id, :user_id, :user_name, :body)
  end
end
