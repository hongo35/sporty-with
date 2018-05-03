class WelcomeController < ApplicationController
  def index
    redirect_to home_index_path if current_user
  end

  def search
    binding.pry


    @clubs = []
    Club.all.each do |c|
      @clubs << [c.name, c.id]
    end
  end
end
