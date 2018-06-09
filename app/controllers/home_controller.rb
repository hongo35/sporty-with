class HomeController < ApplicationController
  before_action  :authenticate_user!

  def index
    tids = TeamUser.where('user_id = ? AND role = 1', current_user.id).pluck(:team_id)

    @teams = Team.where('id IN (?)', tids)

    @team_member_cnt = {}
    tids.each do |tid|
      @team_member_cnt[tid] = TeamUser.where('team_id = ? AND role != 0', tid).count
    end

  end
end
