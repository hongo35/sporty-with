class HomeController < ApplicationController
  before_action  :authenticate_user!

  def index
    gids = []
    GroupUser.where('user_id = ?', current_user.id).each do |gu|
      gids << gu.group_id
    end
    @groups = Group.where('id IN (?)', gids)

    @clubs = {}
    Club.all.each do |c|
      @clubs[c.id] = {
        'name' => c.name,
        'url'  => c.url
      }
    end
  end
end
