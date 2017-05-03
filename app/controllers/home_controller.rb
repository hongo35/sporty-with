class HomeController < ApplicationController
  before_action  :authenticate_user!

  def index
    gids = []
    GroupUser.where('user_id = ?', current_user.id).each do |gu|
      gids << gu.group_id
    end
    @groups = Group.where('id = ?', gids)
  end
end
