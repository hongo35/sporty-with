class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  # protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    home_index_path
  end
end
