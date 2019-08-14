class InvitesController < ApplicationController
  def member
    @user = User.find_by(id: params['uid'])

    tids = TeamUser.where(user_id: @user.id).pluck(:team_id)

    @team = nil
    Team.where(id: tids).each do |t|
      md5 = Digest::MD5.new.update(t.id.to_s).to_s[5...25]

      if params['tid'] == md5
        @team = t
      end
    end

    if current_user.present?
      tu = TeamUser.find_by(team_id: @team.id, user_id: current_user.id)
      if tu.blank?
        TeamUser.create(
          team_id: @team.id,
          user_id: current_user.id,
          role: 10
        )
      end

      redirect_to team_path(@team)
    end
  end
end
