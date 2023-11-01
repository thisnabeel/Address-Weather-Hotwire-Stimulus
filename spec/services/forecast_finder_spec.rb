# spec/services/forecast_finder_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe ForecastFinder, type: :service do
  describe '.call' do
    it 'returns forecast data for valid coordinates' do
      coordinates = '37.7749,-122.4194'

      # Stub the HTTP request using WebMock
      stub_request(:get, /weather.visualcrossing.com/).
        with(query: hash_including(key: ENV['VISUAL_CROSSING_API_KEY'])).
        to_return(
          body: {
            key: ENV['VISUAL_CROSSING_API_KEY'],
            coordinates: coordinates,
            forecast: {
              summary: 'Sunny',
              temperature: 25
              # Add other forecast attributes based on the actual API response structure
            }
          }.to_json,
          headers: { 'Content-Type': 'application/json' }
        )

      forecast_data = ForecastFinder.call(coordinates)

      expect(forecast_data).to be_a(Hash)
    #   expect(forecast_data['coordinates']).to eq(coordinates)
    #   expect(forecast_data['forecast']['summary']).to eq('Sunny')
    #   expect(forecast_data['forecast']['temperature']).to eq(25)
      # Add more expectations based on the actual structure of the forecast response
    end

    it 'returns nil for invalid coordinates' do
        coordinates = '300444196,31.23571po'

        # Stub the HTTP request using WebMock
        stub_request(:get, /weather.visualcrossing.com/).
            with(query: hash_including(key: ENV['VISUAL_CROSSING_API_KEY']))
        
        forecast_data = ForecastFinder.call(coordinates)

        expect(forecast_data).to be_nil
    end
  end
end