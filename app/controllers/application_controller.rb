class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  # protect_from_forgery with: :exception

  before_action :set_account

  def after_sign_in_path_for(resource)
    home_index_path
  end

  private

  def set_account
    if current_user.present?
      @account = Account.find_by(user_id: current_user.id)
      if @account.blank?
        @account = Account.create(
          user_id: current_user.id,
          user_name: current_user.name
        )
      end
    end
  end
end
