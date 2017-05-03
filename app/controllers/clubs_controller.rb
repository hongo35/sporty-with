class ClubsController < ApplicationController
  def index
  end

  def search
    @club = Club.find_by(id: params['cid'])
    if @club.blank?
      redirect_to home_index_path, alert: 'スポーツクラブを選択してください'
    end
    
    @groups = Group.where(club_id: params['cid'])
  end
end
