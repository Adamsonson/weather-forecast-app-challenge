class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home location]

  def home
    @cities = City.all
  end

  def location
    @city = City.new(name: params[:location][:city_name])
    @city.payload = City.get_weather(@city.name)
    if @city.save
      redirect_to root_path, flash: { notice: 'city added' }
    else
      redirect_to root_path, flash: { alert: 'city does not exist' }
    end
  end
end
