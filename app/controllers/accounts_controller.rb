class AccountsController < ApplicationController
  before_action :set_select_account
  
  def show
    tids = TeamUser.where('user_id = ? AND role > 0', @select_account.user_id).pluck(:team_id)

    @img_url = @select_account.img.url
    @img_url = current_user.profile_img_url if @img_url.blank?

    @teams = Team.where('id IN (?)', tids)
  end

  def edit
    redirect_to account_path(@account), alert: 'その操作は許可されていません' if @account.id != @select_account.id
  end

  def update
    redirect_to account_path(@account), alert: 'その操作は許可されていません' if @account.id != @select_account.id

    if @account.update(account_params)
      redirect_to root_path, notice: 'アカウント情報を更新しました。'
    else
      render :edit
    end
  end

  private

  def set_select_account
    @select_account = Account.find_by(id: params[:id])
    redirect_to root_path, alert: 'そのアカウントは存在しません。' if @select_account.blank?
  end

  def account_params
    params.require(:account).permit(:user_name, :img, :img_cache)
  end
end
