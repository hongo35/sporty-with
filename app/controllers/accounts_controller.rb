class AccountsController < ApplicationController
  def show
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to root_path, notice: 'アカウント情報を更新しました。'
    else
      render :edit
    end
  end

  private

  def account_params
    params.require(:account).permit(:user_name, :img, :img_cache)
  end
end
