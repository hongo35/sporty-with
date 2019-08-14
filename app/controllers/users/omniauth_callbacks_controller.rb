class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def facebook
    user = User.find_by("provider != 'facebook' AND email = ?", request.env["omniauth.auth"].info.email)
    return redirect_to new_registration_path('user'), alert: 'メールアドレスがすでに利用されています。' if user.present?

    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def line
    # user = User.find_by("provider != 'line' AND uid = ?", request.env["omniauth.auth"].uid)
    # return redirect_to new_registration_path('user'), alert: 'このアカウントはすでに利用されています。' if user.present?

    @user = User.find_for_line_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      set_flash_message(:notice, :success, :kind => "LINE") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
