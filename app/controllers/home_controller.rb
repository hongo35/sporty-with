class HomeController < ApplicationController
  before_action  :authenticate_user!

  def index
    tids = TeamUser.where('user_id = ? AND role > 0', current_user.id).pluck(:team_id)

    @teams = Team.where('id IN (?)', tids)

    @next_event = {}
    tids.each do |tid|
      @next_event[tid] = {
        'event_id' => nil,
        'subject'  => '---',
        'start_at' => '---'
      }

      e = Event.where('team_id = ? AND start_at > NOW()', tid).order('start_at ASC').first
      if e.present?
        @next_event[tid]['event_id'] = e.id
        @next_event[tid]['subject'] = e.subject
        @next_event[tid]['start_at'] = e.start_at.strftime('%m月%d日 %H:%M')
      end
    end

    @sports = {}
    Sport.all.each do |s|
      @sports[s.id] = s.name
    end

    @team_member_cnt = {}
    tids.each do |tid|
      @team_member_cnt[tid] = TeamUser.where('team_id = ? AND role > 0', tid).count
    end
  end

  def ajax_push
    current_user.update(endpoint: params['endpoint'])

    render json: []
  end
end
