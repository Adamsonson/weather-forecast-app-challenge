class CitiesController < ApplicationController
  def show
    @city = City.find(params[:id])
    authorize @city
  end

  def create
    @city = City.new(name: params[:location][:city_name].downcase)
    @city.user = current_user
    @city.payload = City.get_weather(@city.name)
    @city.photo = City.get_city_picture(@city.name)
    authorize @city
    if @city.save
      redirect_to root_path, flash: { notice: 'City added' }
    else
      redirect_to root_path, flash: { alert: 'City does not exist or already in the list' }
    end
  end

  def refresh
    @cities = City.all
    authorize @cities

    @cities.each do |city|
      city.update(payload: City.get_weather(city.name))
    end

    redirect_to root_path
  end

  def destroy
    @city = City.find(params[:id])
    authorize @city
    @city.destroy

    redirect_to root_path

    # AJAX to be finished

    #   respond_to do |format|
    #   if @result = @city.destroy
    #     format.html { redirect_to root_url }
    #     format.js
    #   else
    #     format.html {
    #       @city.errors.full_messages.each do |msg|
    #         flash[:danger] = msg
    #       end
    #       redirect_to root_url
    #     }
    #     format.js
    #   end
    # end
  end

  def api; end
end
