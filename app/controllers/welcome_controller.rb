class WelcomeController < ApplicationController
  def index
    if current_user
      redirect_to home_index_path
    else
      @clubs = []
      Club.all.each do |c|
        @clubs << [c.name, c.id]
      end
    end
  end
end
