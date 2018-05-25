class WelcomeController < ApplicationController
  def index
    redirect_to home_index_path if current_user
  end
end
