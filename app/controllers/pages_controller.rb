class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @cities = City.all.order(created_at: :desc)
  end

  def help
  end
end
