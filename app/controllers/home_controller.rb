class HomeController < ApplicationController
  before_action  :authenticate_user!

  def index
    tids = []
    TeamUser.where('user_id = ?', current_user.id).each do |tu|
      tids << tu.team_id
    end
    @teams = Team.where('id IN (?)', tids)

    @clubs = {}
    Club.all.each do |c|
      @clubs[c.id] = {
        'name' => c.name,
        'url'  => c.url
      }
    end
  end
end
