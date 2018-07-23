class HomeController < ApplicationController
  before_action  :authenticate_user!

  def index
    tids = TeamUser.where('user_id = ? AND role > 0', current_user.id).pluck(:team_id)

    uids = TeamUser.where('team_id IN (?) AND role > 0', tids).pluck(:user_id).uniq

    events = {}
    Event.where('team_id IN (?)', tids).each do |e|
      events[e.id] = {
        'name' => e.subject
      }
    end

    users = {}
    Account.where('user_id IN (?)', uids).each do |a|
      users[a.user_id] = {
        'name'    => a.user_name,
        'img_url' => a.img.url
      }
    end

    @teams = {}
    Team.where('id IN (?)', tids).each do |t|
      @teams[t.id] = {
        'name'     => t.team_name,
        'img_url'  => t.img.url,
        'location' => t.location
      }
    end

    @timelines = []
    Timeline.where('user_id = ?', current_user.id).order('Created_at DESC').limit(10).each do |t|
      week_day = WEEKDAY[t.created_at.strftime("%w").to_i]

      @timelines << {
        'action_type' => t.action_type,
        'action_user_id' => t.action_user_id,
        'user_name' => users[t.action_user_id]['name'],
        'img_url'   => users[t.action_user_id]['img_url'],
        'team_id'   => t.team_id,
        'team_name' => @teams[t.team_id]['name'],
        'event_id'   => t.event_id,
        'event_name' => events[t.event_id]['name'],
        'comment'   => t.comment,
        'created_at' => t.created_at.strftime('%-m月%-d日('+week_day+') %-H:%M')
      }
    end

    @events = []
    Event.where("team_id IN (?) AND start_at > NOW()", tids).order('start_at ASC').limit(3).each do |e|
      week_day = WEEKDAY[e.start_at.strftime("%w").to_i]

      @events << {
        'team_id'   => e.team_id,
        'team_name' => @teams[e.team_id]['name'],
        'img_url'   => @teams[e.team_id]['img_url'],
        'event_id'  => e.id,
        'subject'   => e.subject,
        'start_at'  => e.start_at.strftime('%-m月%-d日('+week_day+') %-H:%M')
      }
    end
  end

  def ajax_push
    current_user.update(endpoint: params['endpoint'])

    render json: []
  end
end
