class WeatherController < ApplicationController
  def forecast
    coordinates = CoordinatesFinder.call(params[:place_id])
    @forecast = ForecastFinder.call(coordinates)
    render json: render_to_string(partial: 'weather/forecast', locals: { forecast: @forecast })
  end
end